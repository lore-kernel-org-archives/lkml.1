Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXJXFKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXJXFKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbXJXFKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:10:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52524 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbXJXFKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:10:10 -0400
Date: Tue, 23 Oct 2007 22:06:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
Message-ID: <20071023220649.5a76af82@laptopd505.fenrus.org>
In-Reply-To: <471E9260.6000704@goop.org>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
	<alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
	<200710192226.53233.agruen@suse.de>
	<alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
	<Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
	<Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
	<20071022210956.31f7bbcf@laptopd505.fenrus.org>
	<20071023051642.GA3908@sequoia.sous-sol.org>
	<471E9260.6000704@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 17:31:28 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Chris Wright wrote:
> > Yes, and I think we can still improve performance although I can't
> > see anyway to help out the modular case, so I guess it will have to
> > incur the hit that's always been there.  
> 
> Broaden the paravirt patching machinery?
> 

so far I've something much simpler in mind, I have a first prototype
and it shows code that is pretty much optimal on modern cpus.

I hope to have something postable in a week or so
