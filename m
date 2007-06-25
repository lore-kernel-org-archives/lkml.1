Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbXFYOue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbXFYOue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbXFYOu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:50:26 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:33469 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbXFYOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:50:25 -0400
Date: Mon, 25 Jun 2007 16:48:12 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: david@lang.hm
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
Message-ID: <467fd5ac.p+nL2jK1/2ZfUDRF%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:

> On Fri, 22 Jun 2007, Joerg Schilling wrote:
>
> > Is there some hope that at least the Linux kernel interface definition files and
> > everything recursively included from these files will be rewritten in vanilla
> > ANSI C?
>
> this has been discussed many times and the answer is that the kernel is 
> not gong to change it's side of things to ANSI C.

Well, there is no need to go to ANSI C as pre-ANSI would to it also.
The problem is non ANSI gcc extensions.

> that doesn't mean that one of the many projects out there to create 
> seperate interface headers won't do this.
>
> however, there is another interesting thing going on at the moment. The 
> standards commity is currently deciding what will be in the next rev of 
> the C specs (tentitivly labels C1x for discussions, they are hopeing to 
> release them in '09 or '10)
>
> some of the things that are GCC extentions are going to be added to the 
> spec (ahtough possibly with a change to the syntax)

This may make sense after it did happen, but it does not help today.

> so now is the time to talk to your local reps who go to these meetings and 
> make your suggestions for what should be added to the standard and what 
> should not be.
>
> remember that anything to be added must be implemented somehwere, 
> preferrably by multiple seperate compilers.

Using plain C in the Linux kernel include files would be sufficient for all
compilers that make sense to be supported.


Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
