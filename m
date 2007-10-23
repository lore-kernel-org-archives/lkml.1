Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbXJWFAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbXJWFAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXJWFAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:00:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58311 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXJWFAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:00:36 -0400
Date: Mon, 22 Oct 2007 21:57:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
Message-ID: <20071022215739.121e5ea3@laptopd505.fenrus.org>
In-Reply-To: <Xine.LNX.4.64.0710231450450.31564@us.intercode.com.au>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
	<alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
	<200710192226.53233.agruen@suse.de>
	<alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
	<Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
	<Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
	<20071022210956.31f7bbcf@laptopd505.fenrus.org>
	<Xine.LNX.4.64.0710231450450.31564@us.intercode.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 14:56:52 +1000 (EST)
James Morris <jmorris@namei.org> wrote:

> On Mon, 22 Oct 2007, Arjan van de Ven wrote:
> 
> > @@ -4895,6 +4908,7 @@ static struct security_operations selinu
> >  	.sem_semop =			selinux_sem_semop,
> >  
> >  	.register_security =
> > selinux_register_security,
> > +	.unregister_security =
> > selinux_unregister_security, 
> >  	.d_instantiate =                selinux_d_instantiate,
> 
> You also need to consider whether to allow capabilities to be built
> as an unloadable module.  If not, then we don't need this hook added
> back into SELinux.  Otherwise, if it is desired, you also need to
> reinstate capability_exit and general modular bits for
> security/capability.c.
> 

this just allows 3d party replacements of capability like functions;
there is no need/point to have the existing capability back as modular
to be honest.
