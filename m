Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbXFYPIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbXFYPIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXFYPIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:08:36 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:33547 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754974AbXFYPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:08:35 -0400
Date: Mon, 25 Jun 2007 17:06:27 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: david@lang.hm, arnd@arndb.de
Cc: vapier.adi@gmail.com, schilling@fokus.fraunhofer.de,
       linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
Message-ID: <467fd9f3.Vc25RVyWdnB9qPjQ%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <200706220159.07948.arnd@arndb.de>
In-Reply-To: <200706220159.07948.arnd@arndb.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 22 June 2007, david@lang.hm wrote:
> > this has been discussed many times and the answer is that the kernel is 
> > not gong to change it's side of things to ANSI C.
>
> I don't think that's entirely true with regard to the include files.
> We have always tried not to step on anyone's toes there, e.g. regarding
> the use of __u32 vs. uint32_t style types. It's certainly desirable
> to make the kernel headers that are _meant_ for inclusion compatible
> with standard compilers.
>
> Mike Frysinger has posted a few patches that make the installed headers
> friendlier to strict C99 users. While there was some negative feedback
> about these patches, it was not about the idea of making the installed
> headers C99 clean, but rather about the question whether those non-clean
> parts should be exported in the first place.

Wouldn't it be simpler to ask the developers to deliver their include files
in a state that is clean for user space programs?

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
