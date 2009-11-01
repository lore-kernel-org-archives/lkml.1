Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZKAUkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZKAUkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 15:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZKAUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 15:40:23 -0500
Received: from icculus.org ([67.106.77.212]:45293 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbZKAUkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 15:40:23 -0500
Date: Sun, 1 Nov 2009 15:40:23 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.local
To: David Hagood <david.hagood@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <1257103201.2865.6.camel@chumley>
Message-ID: <alpine.OSX.1.10.0911011531570.53392@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Format (ANDF), such that, given a fat binary which does NOT support a
> given CPU, you could at least in theory process the ANDF section to
> create the needed target binary? Bonus points for being able to then
> append the newly created section to the file.

It's not a goal of mine, but I suppose you could have an ELF OSABI for it.

I don't think it changes the FatELF kernel patch at all. I don't know much 
about ANDF, but you'd probably just want to set the ELF "interpreter" to 
something other than ld.so and do this all in userspace, and maybe add a 
change to elf_check_arch() to approve ANDF binaries...or something.

To me, ANDF is interesting in an academic sense, but not enough to spend 
effort on it. YMMV.  :)

--ryan.


