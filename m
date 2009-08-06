Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZHFKJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZHFKJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZHFKJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:09:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZHFKJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:09:31 -0400
Message-ID: <4A7AACF1.9040400@redhat.com>
Date: Thu, 06 Aug 2009 13:14:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Rik van Riel <riel@redhat.com>, "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <4A79C70C.6010200@redhat.com> <9EECC02A4CC333418C00A85D21E89326B651C1FE@azsmsx502.amr.corp.intel.com> <4A79D88E.2040005@redhat.com> <9EECC02A4CC333418C00A85D21E89326B651C21C@azsmsx502.amr.corp.intel.com> <4A7AA0CF.2020700@redhat.com> <20090806092516.GA18425@localhost> <4A7AA3FF.9070808@redhat.com> <20090806093507.GA24669@localhost> <4A7AA999.8050309@redhat.com> <20090806095905.GA30410@localhost>
In-Reply-To: <20090806095905.GA30410@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 12:59 PM, Wu Fengguang wrote:
>> Do we know for a fact that only stack pages suffer, or is it what has
>> been noticed?
>>      
>
> It shall be the first case: "These pages are nearly all stack pages.",
> Jeff said.
>    

Ok.  I can't explain it.  There's no special treatment for guest stack 
pages.  The accessed bit should be maintained for them exactly like all 
other pages.

Are they kernel-mode stack pages, or user-mode stack pages (the 
difference being that kernel mode stack pages are accessed through large 
ptes, whereas user mode stack pages are accessed through normal ptes).

-- 
error compiling committee.c: too many arguments to function

