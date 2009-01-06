Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZAFWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZAFWjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZAFWeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:34:03 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:20881 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225AbZAFWeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:34:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h9SM3J2SQGNqtTIs40hRTAelnXIDfLVS0tLu1zyVQmdoKQnR3uga72QhhoOO3CJfAY
         y1Mi26g1X4I+fCPy2vQ3WVobuXpqRl8LlqeQOeHpJHH44HJBd4+49V1J/ZJa9/5twuUp
         CCvy6M4PIM5UWagYA2sOjDdmwjcSqeY85Z/kk=
Subject: Re: [PATCH 01/23] byteorder: only use linux/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Chris Zankel <chris@zankel.net>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Gerd Hoffmann <kraxel@redhat.com>, bluebird <bluebird@gentoo.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901061407120.3057@localhost.localdomain>
References: <1231277444.964.258.camel@brick>
	 <alpine.LFD.2.00.0901061407120.3057@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 14:32:33 -0800
Message-Id: <1231281153.25147.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 14:08 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Jan 2009, Harvey Harrison wrote:
> >
> > The first step to make swab.h a regular header that will
> > include an asm/swab.h with arch overrides.
> 
> Btw, was there some reason why you didn't just do the <asm/swab.h> files 
> first? That would seem to simplify the whole sequence, and in fact it 
> would also allow me to just apply all the "create asm/swab.h" patches 
> first regardless of any other work..
> 
> 		Linus


My goal was the elimination of the linux/byteorder.h you objected to while
not breaking the arch overrides of the arches that had already converted.

So it's not just moving to swab.h, it also eliminates the linux/byteorder.h
includes, for this to work, I need to fix swab.h first.

Harvey

