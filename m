Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXGWLI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXGWLI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbXGWLIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:08:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:36280 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbXGWLIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:08:17 -0400
Message-ID: <46A48C2A.5060804@qumranet.com>
Date: Mon, 23 Jul 2007 14:08:26 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 3/8]KVM: convert vm lock to a mutex
References: <1185173497.2645.67.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185173497.2645.67.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> convert kvm lock to a mutex.
>
> TBD: after this change, a lot of logic in kvm can be simplified, eg, we
> don't need release lock and then do operation blocking.
>   

This is now in the preempt-hooks branch.


-- 
error compiling committee.c: too many arguments to function

