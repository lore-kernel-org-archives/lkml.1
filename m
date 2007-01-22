Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXAVUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXAVUES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbXAVUES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:04:18 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:3565 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932113AbXAVUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:04:16 -0500
Date: Mon, 22 Jan 2007 21:04:23 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Kristian =?iso-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [-mm patch] drivers/firewire/: cleanups
Message-ID: <20070122200423.GA9093@stusta.de>
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070122181736.GU9093@stusta.de> <45B51369.1060408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45B51369.1060408@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 02:41:29PM -0500, Kristian Høgsberg wrote:
> Adrian Bunk wrote:
> >On Thu, Jan 11, 2007 at 10:26:27PM -0800, Andrew Morton wrote:
> >>...
> >>Changes since 2.6.20-rc3-mm1:
> >>...
> >> git-ieee1394.patch
> >>...
> >> git trees
> >>...
> >
> >
> >This patch contains the following cleanups:
> >- "extern inline" -> "static inline"
> 
> I guess that's fine, I do like how extern inline will never generate code 

Exactly the opposite will be true when gcc will switch to the C99 
semantics...

Besides this, "static inline" forces inlining in the kernel due to
  #define inline          inline          __attribute__((always_inline))

> and that gcc warns on missing prototype for these case is more of a gcc 
> bug.  Not a big deal though, it's more worthwhile to track down real 
> missing prototype offenders.
> 
> >- fw-topology.c: make struct fw_node_create static
> 
> Looks good.
> 
> Signed-off-by: Kristian Høgsberg <krh@redhat.com>
> 
> 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

