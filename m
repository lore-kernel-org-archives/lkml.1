Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbXELTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbXELTAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbXELTA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:00:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbXELTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:00:27 -0400
Message-ID: <46460E9E.9020308@zytor.com>
Date: Sat, 12 May 2007 11:59:42 -0700
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
References: <464158E9.2000207@zytor.com>	<1178806235.18785.1189115515@webmail.messagingengine.com>	<46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com>	<4643A128.30302@zytor.com> <20070512122137.GA25944@mailshack.com>	<m1r6pmqg1n.fsf@ebiederm.dsl.xmission.com>	<464602DC.4050603@zytor.com> <m1mz09ritr.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1mz09ritr.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Even on 386 and 486 class cpus?
> 

Yes, even on 386 and 486 class CPUs.  I have personally tested this on
machines as old as the original "double sigma" 386-16.

> To some extent if the rules don't change it makes sense for them to
> copy the information from one generation to the next of the architecture.
> Even if the current cpus don't really care.
> 
> I guess I just don't see the sense in taking chances if we don't have
> to, and I don't see any real advantage of doing a data segment reload
> before the jump.

It makes the code cleaner -- more debuggable -- by introducing clean
separation between 16- and 32-bit code.

	-hpa
