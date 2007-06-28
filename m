Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbXF1AbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbXF1AbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 20:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbXF1AbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 20:31:09 -0400
Received: from ns.suse.de ([195.135.220.2]:51307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbXF1AbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 20:31:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Userspace compiler support of "long long"
Date: Thu, 28 Jun 2007 02:30:42 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
In-Reply-To: <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706280230.42515.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007 00:30:52 Kyle Moffett wrote:
> On Jun 27, 2007, at 13:32:40, Adrian Bunk wrote:
> > AFAIR the Intel compiler claims to be gcc.
> >
> > But these are by far not the only C compilers under Linux, and the  
> > more important points are:
> >
> > Is there any userspace Linux compiler that does not support "long  
> > long"?
> 
> Don't know, but I'd guess not.

Tendra C and probably lcc. I would guess tinycc too.

> The only trick is if you care about building 32-bit compat code using  
> 64-bit linux kernel headers.  In that case we should probably just  
> make all archs use "long long" for their 64-bit integers, unless  
> there's some platform I'm not remembering where "long long" is 128- 
> bits or bigger.  The other benefit is that people could then just use  
> the printf format "%llu" for 64-bit integers instead of having to  
> conditionalize it all over the place.
> 
> I'm working on a patch now.

Changing this will give you a zillion warnings for printk formats.

-Andi
 
