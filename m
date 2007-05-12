Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbXELWKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbXELWKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 18:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXELWKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 18:10:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXELWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 18:10:11 -0400
Message-ID: <46463AED.5060800@zytor.com>
Date: Sat, 12 May 2007 15:08:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com>	<1178806235.18785.1189115515@webmail.messagingengine.com>	<46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com>	<4643A128.30302@zytor.com> <20070512122137.GA25944@mailshack.com>	<m1r6pmqg1n.fsf@ebiederm.dsl.xmission.com>	<464602DC.4050603@zytor.com>	<m1mz09ritr.fsf@ebiederm.dsl.xmission.com>	<46460E9E.9020308@zytor.com> <m1iraxr95g.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1iraxr95g.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Ok.  If you have tested on a wide variety of machines then I won't
> worry about it.
> 
> I guess if a cr0 write has always been synchronizing things should be
> a safe practice.  The practical danger is if you write to cr0 and the
> pipeline is not flushed and the segment loads might execute as 16bit
> mode segment register loads.  I think this is more of a 486 or 586/Pentium
> danger actually then a 386 one.

Writes to CR0 are synchronizing and are documented as such.  This is a
fairly trivial consequence of it invoking microcode on every x86 ever
created.

> Hmm. I'm not certain about enabling protected mode but enabling paging
> at least does appear to be documented to require a jump, before the P6
> core.  Which may be why it is recommended for initializing protected
> mode.

Enabling paging is possibly a different matter.  I can't speak on that
particular subject with any authority.

	-hpa
