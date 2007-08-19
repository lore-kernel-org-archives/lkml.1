Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXHSOla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXHSOla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 10:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXHSOlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 10:41:20 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:53331 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXHSOlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 10:41:20 -0400
Date: Sun, 19 Aug 2007 16:40:59 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Benny Amorsen <benny+usenet@amorsen.dk>, linux-kernel@vger.kernel.org
Subject: Re: variable length argument support (was: [OT] Re: The vi editor
 causes brain damage)
Message-ID: <20070819164059.41b86c6b@localhost>
In-Reply-To: <Pine.LNX.4.64.0708191505170.6042@fbirervta.pbzchgretzou.qr>
References: <964583.28477.qm@web52504.mail.re2.yahoo.com>
	<46C7EE0A.2030601@gmail.com>
	<20070819072135.GQ6002@1wt.eu>
	<m37inr1zae.fsf@ursa.amorsen.dk>
	<20070819143956.5d21aa7d@localhost>
	<Pine.LNX.4.64.0708191505170.6042@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 15:07:01 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> >    Remove the arg+env limit of MAX_ARG_PAGES by copying the strings
> >    directly from the old mm into the new mm.  
> 
> Me wonders. Will that make the "checking for maximum length of command line
> arguments" from autotools run forever since execve() will not fail anymore?

Since I'm running Gentoo and do many compiles I can tell that it
works  :)

If I remeber correctly it was discussed on LKML and turend out that
that check is done starting with a "max" len and going down rather than
starting low and going up.

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g2a677896-dirty on x86_64
