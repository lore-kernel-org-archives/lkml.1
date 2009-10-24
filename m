Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZJXAZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZJXAZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 20:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZJXAZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 20:25:52 -0400
Received: from icculus.org ([67.106.77.212]:57094 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZJXAZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 20:25:51 -0400
Date: Fri, 23 Oct 2009 20:25:55 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] binfmt_elf: FatELF support in the binary
 loader.
In-Reply-To: <4AE22B34.7090103@goop.org>
Message-ID: <alpine.OSX.1.10.0910232021000.2186@caridad.icculuslan>
References: <alpine.DEB.2.00.0910190418500.13303@andre.icculuslan> <4ADD005A.4000401@goop.org> <alpine.DEB.2.00.0910200034500.18342@andre.icculuslan> <4AE22B34.7090103@goop.org>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It would be nice to have something that would conceptually work for
> other architectures with other executable file formats.  Granted ELF is
> most common, but its far from the only one.

It would be nice, but I'm not certain it's practical. I mean, if we embed 
a Windows .exe in there, Windows is never going to be able to load it, I 
presume.

That being said, I suppose there's no reason you _couldn't_ do that with 
the existing FatELF format. Just add an OSABI for, say, Windows PE files 
and embed one like anything else. Non-Windows platforms will ignore it 
because it's the wrong OSABI. If something tried to process it as an ELF 
file, it'll correctly believe it to be a corrupt file.

(Replace Windows with your favorite non-ELF platform if you like.)

This isn't really a goal of the project, but since you brought it up, it 
IS actually feasible with the existing code and framework.

> Well, its really a bit diseased, with lots of gristly bits and a few
> unexpected tubes sticking out the side.

Eww.

--ryan.


