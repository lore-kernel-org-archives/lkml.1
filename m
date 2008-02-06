Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYBFU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYBFU61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYBFU6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:58:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60585 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbYBFU6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:58:18 -0500
Date: Wed, 6 Feb 2008 21:58:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REVIEW for merge] kbuild updates including silence of section mismatch check
Message-ID: <20080206205823.GB12043@uranus.ravnborg.org>
References: <20080202203503.GA26415@uranus.ravnborg.org> <Pine.LNX.4.64.0802051116410.1588@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802051116410.1588@vixen.sonytel.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 11:38:49AM +0100, Geert Uytterhoeven wrote:
> On Sat, 2 Feb 2008, Sam Ravnborg wrote:
> > The most visible change is that I have made all the section mismatch
> > go away and in the end of the build modpost report the number
> > of section mismatch warnings and how to see detail.
> > 
> > The typical output is now:
> > 
> > modpost: Found 35 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> 
> Can we get a `warning' string literal in that message, so I notice it when
> grepping for compiler warnings?
> 
> ... Ah, there already exists a warn() routine, so let's use it.
> 
> Subject: modpost: Use warn() for announcing section mismatches

Fair enough. Applied.

	Sam
