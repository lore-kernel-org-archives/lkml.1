Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXGHN7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXGHN7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXGHN7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:59:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbXGHN7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:59:12 -0400
Date: Sun, 8 Jul 2007 15:59:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
Message-ID: <20070708135905.GA24991@elte.hu>
References: <11838994974161-git-send-email-avi@qumranet.com> <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com> <20070708134850.GB22911@elte.hu> <4690EC47.6060904@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4690EC47.6060904@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> >> Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  
> >> The function pointers are common to all virtual machines.
> >
> > well, this function pointer could then be reused by other virtual 
> > machines as well, couldnt it?
> 
> I don't get this.  If we add a couple of members to task_struct, it 
> can't be reused.  The values will be the same across all tasks, but 
> the memory will be gone (including tasks which aren't virtual 
> machines).

i mean, the function pointer is set by KVM, but it could be set to a 
different value by other hypervisors.

but ... no strong feelings either way, your patch is certainly fine.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
