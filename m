Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbXELWFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbXELWFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 18:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbXELWFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 18:05:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51864 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXELWFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 18:05:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com>
	<1178806235.18785.1189115515@webmail.messagingengine.com>
	<46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com>
	<4643A128.30302@zytor.com> <20070512122137.GA25944@mailshack.com>
	<m1r6pmqg1n.fsf@ebiederm.dsl.xmission.com>
	<464602DC.4050603@zytor.com>
	<m1mz09ritr.fsf@ebiederm.dsl.xmission.com>
	<46460E9E.9020308@zytor.com>
Date: Sat, 12 May 2007 16:04:27 -0600
In-Reply-To: <46460E9E.9020308@zytor.com> (H. Peter Anvin's message of "Sat,
	12 May 2007 11:59:42 -0700")
Message-ID: <m1iraxr95g.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> Even on 386 and 486 class cpus?
>> 
>
> Yes, even on 386 and 486 class CPUs.  I have personally tested this on
> machines as old as the original "double sigma" 386-16.

Ok.  If you have tested on a wide variety of machines then I won't
worry about it.

I guess if a cr0 write has always been synchronizing things should be
a safe practice.  The practical danger is if you write to cr0 and the
pipeline is not flushed and the segment loads might execute as 16bit
mode segment register loads.  I think this is more of a 486 or 586/Pentium
danger actually then a 386 one.

Hmm. I'm not certain about enabling protected mode but enabling paging
at least does appear to be documented to require a jump, before the P6
core.  Which may be why it is recommended for initializing protected
mode.

Eric
