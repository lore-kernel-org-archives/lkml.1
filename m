Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZEDIBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZEDIBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZEDIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:01:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31857 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZEDIBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:01:11 -0400
Date: Mon, 4 May 2009 10:00:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Anders Kaseorg <andersk@MIT.EDU>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modpost: more complete endianness fixing
Message-ID: <20090504100045.4bfe5591@hyperion.delvare>
In-Reply-To: <20090503194848.GA32400@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare>
	<20090503103010.GA27978@uranus.ravnborg.org>
	<20090503204218.6c65c740.sfr@canb.auug.org.au>
	<alpine.DEB.2.00.0905031403300.28205@vinegar-pot.mit.edu>
	<20090503194848.GA32400@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009 21:48:48 +0200, Sam Ravnborg wrote:
> On Sun, May 03, 2009 at 02:07:35PM -0400, Anders Kaseorg wrote:
> > Fix endianness of all the fields in the ELF header and section headers, 
> > not just some of them.
> > 
> > The missing TO_NATIVE(sechdrs[i].sh_flags) was causing many “unexpected 
> > non-allocatable section” warnings when cross-compiling for an architecture 
> > with a different endianness.
> 
> Thanks Anders.
> Makes sense for the powerpc case.
> But I cannot see it fixing the warnings Jean sees.
> 
> Jean?

It indeed didn't help me (but your other fix did.)

-- 
Jean Delvare
