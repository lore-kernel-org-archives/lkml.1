Return-Path: <linux-kernel-owner+w=401wt.eu-S935292AbXGRSeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbXGRSeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761676AbXGRSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:34:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37534 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757984AbXGRSei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:34:38 -0400
Date: Wed, 18 Jul 2007 20:33:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718183359.GK3801@stusta.de>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <469E3806.4030804@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 08:55:50AM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > 
> >> Already with these patches I can compile a zImage kernel that is 450kb
> >> large (890kb decompressed)
> > 
> > The important part is not how big the vmlinux is, but how much
> > memory is actually used after boot. 
> > 
> > I expect concentrating some of the dynamic data structures would
> > be more fruitful in fact.
> > 
> 
> Well, how big the vmlinux file is matters if it doesn't fit in memory
> with enough time to get to the phase where it is dumping the init
> sections.  *If that is not the issue*, then axing stuff like CPUID is a
> major lose in terms of code maintainability for zero gain.

If this is an issue, then changing i386 back to discarding __exit code 
and data at linktime instead of runtime might make a bigger difference.

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

