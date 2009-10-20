Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZJTEnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZJTEnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZJTEnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:43:14 -0400
Received: from icculus.org ([67.106.77.212]:37636 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZJTEnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:43:14 -0400
Date: Tue, 20 Oct 2009 00:43:09 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] binfmt_elf: FatELF support in the binary
 loader.
In-Reply-To: <4ADD005A.4000401@goop.org>
Message-ID: <alpine.DEB.2.00.0910200034500.18342@andre.icculuslan>
References: <alpine.DEB.2.00.0910190418500.13303@andre.icculuslan> <4ADD005A.4000401@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The idea seem interesting, but does it need to be ELF-specific?  What
> about making the executable a simple archive file format (possibly just
> an "ar" archive?) which contains other executables.  The archive file
> format would be implemented as its own binfmt, and the internal
> executables could be arbitrary other executables.  The outer loader
> would just try execing each executable until one works (or it runs out).

I'm not sure the added flexibility is worth the extra complications. 
FatELF solves a specific problem: merging multiple ELF targets into one 
file, the most compelling use-case being to glue x86_64 and i686 binaries 
together.

What you're describing would definitely be the route I'd have chosen if, 
say, a.out files were still in widespread use and actively competed with 
ELF for mindshare.

> That is, what you have here, but without hacking up binfmt_elf more.

I like to think of it as art, like a chef carving a fine piece of meat. :)

--ryan.

