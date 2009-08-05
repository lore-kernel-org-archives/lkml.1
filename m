Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZHETJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZHETJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZHETJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:09:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48510 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbZHETJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:09:36 -0400
Message-ID: <4A79D88E.2040005@redhat.com>
Date: Wed, 05 Aug 2009 15:07:58 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <4A79C70C.6010200@redhat.com> <9EECC02A4CC333418C00A85D21E89326B651C1FE@azsmsx502.amr.corp.intel.com>
In-Reply-To: <9EECC02A4CC333418C00A85D21E89326B651C1FE@azsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dike, Jeffrey G wrote:
>> Also, the inactive list (where references to anonymous pages
>> _do_ count) is pretty big.  Is it not big enough in Jeff's
>> test case?
> 
>> Jeff, what kind of workloads are you running in the guests?
> 
> I'm looking at KVM on small systems.  My "small system" is a 128M memory compartment on a 4G server.

How did you create that 128M memory compartment?

Did you use cgroups on the host system?

> The workload is boot up the instance, start Firefox and another app (whatever editor comes by default with Moblin), close them, and shut down the instance.

How much memory do you give your virtual machine?

That is, how much memory does it think it has?

-- 
All rights reversed.
