Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZAGFJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZAGFJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZAGFJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:09:03 -0500
Received: from relais.videotron.ca ([24.201.245.36]:41532 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZAGFJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:09:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 07 Jan 2009 00:08:54 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
In-reply-to: <alpine.LFD.2.00.0901062056540.3057@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0901070005530.26118@xanadu.home>
References: <200901070400.n0740Ore002063@hera.kernel.org>
 <1231303340.14860.61.camel@pasglop>
 <alpine.LFD.2.00.0901062056540.3057@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, Linus Torvalds wrote:

> 
> 
> On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> > 
> > Was this tested ? I see no arch maintainer signed-off here, it appears
> > to at least break ppc32, and contains hunks that paulus says were
> > explicitely nacked (removing of our ld_* macros) etc...
> 
> It did no such thing. It just moved the file.
> 
> Use
> 
> 	git show -M -B 156ca2bbf6503a02d7d6829886ce381d572de66e
> 
> to see how <asm/swab.h> is just the old <asm/byteorder.h> renamed, and 
> with some stuff moved around.

I suspect that all archs that define __SWAB_64_THRU_32__ are broken atm.

According to "git grep ___swab32", there is no more definition for 
___swab32 anywhere.


Nicolas
