Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYBJJyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYBJJyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYBJJy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:54:28 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:56960 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYBJJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:54:27 -0500
Date: Sun, 10 Feb 2008 10:54:24 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unifdef linux/vt.h
Message-ID: <20080210095424.GA28283@aepfle.de>
References: <20080125180215.GA30039@aepfle.de> <20080208173810.GA22895@aepfle.de> <20080208132941.994229f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080208132941.994229f7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, Andrew Morton wrote:

> On Fri, 8 Feb 2008 18:38:10 +0100
> Olaf Hering <olaf@aepfle.de> wrote:
> 
> > On Fri, Jan 25, Olaf Hering wrote:
> > 
> > > remove the newly added __KERNEL__ block from linux/vt.h
> > 
> > Can you pick this up? The patch cant get any better.
> 
> spose so.  Coud you send a tested version against current mainline please?

Its already fixed.

 commit 7998a731664ac4988b349e70669bac11e3b3a3ac
 Author: Robert P. J. Day <rpjday@crashcourse.ca>
 Date:   Mon Dec 31 14:58:38 2007 +0100

    A few corrections to include/linux/Kbuild
    
    auxvec.h, i2c-dev.h and vt.h *should* be unifdef'ed i2o-dev.h does not need
    unifdef'ing
    
    Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
    Cc: David Woodhouse <dwmw2@infradead.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
