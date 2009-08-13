Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZHMQNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZHMQNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 12:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZHMQNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 12:13:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbZHMQNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 12:13:13 -0400
Message-ID: <4A843B72.6030204@redhat.com>
Date: Thu, 13 Aug 2009 19:12:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com> <20090807121443.5BE5.A69D9226@jp.fujitsu.com> <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com>
In-Reply-To: <4A843565.3010104@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 06:46 PM, Rik van Riel wrote:
> We need to ignore the referenced bit on active anon pages
> on very large systems, but it could indeed be helpful to
> respect the referenced bit on smaller systems.
>
> I have no idea where the cut-off between them would be.
>
> Maybe at inactive_ratio <= 4 ?

Why do we need to ignore the referenced bit in such cases?  To avoid 
overscanning?

-- 
error compiling committee.c: too many arguments to function

