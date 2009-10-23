Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbZJWWQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbZJWWQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 18:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZJWWQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 18:16:18 -0400
Received: from claw.goop.org ([74.207.240.146]:42716 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZJWWQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 18:16:17 -0400
Message-ID: <4AE22B34.7090103@goop.org>
Date: Fri, 23 Oct 2009 15:16:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Ryan C. Gordon" <icculus@icculus.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] binfmt_elf: FatELF support in the binary loader.
References: <alpine.DEB.2.00.0910190418500.13303@andre.icculuslan> <4ADD005A.4000401@goop.org> <alpine.DEB.2.00.0910200034500.18342@andre.icculuslan>
In-Reply-To: <alpine.DEB.2.00.0910200034500.18342@andre.icculuslan>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/09 21:43, Ryan C. Gordon wrote:
> I'm not sure the added flexibility is worth the extra complications. 
> FatELF solves a specific problem: merging multiple ELF targets into one 
> file, the most compelling use-case being to glue x86_64 and i686 binaries 
> together.
>
> What you're describing would definitely be the route I'd have chosen if, 
> say, a.out files were still in widespread use and actively competed with 
> ELF for mindshare.
>   

It would be nice to have something that would conceptually work for
other architectures with other executable file formats.  Granted ELF is
most common, but its far from the only one.

A generic approach would allow the last-option fallback executable to be
a shell/python/perl script which could do something useful (like display
a useful message).

>> That is, what you have here, but without hacking up binfmt_elf more.
>>     
> I like to think of it as art, like a chef carving a fine piece of meat. :)
>   

Well, its really a bit diseased, with lots of gristly bits and a few
unexpected tubes sticking out the side.

    J
