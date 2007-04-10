Return-Path: <linux-kernel-owner+w=401wt.eu-S1030453AbXDJHLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453AbXDJHLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030457AbXDJHLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:11:42 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56211 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030453AbXDJHLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:11:42 -0400
Date: Tue, 10 Apr 2007 09:12:17 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Dave Dillow <dave@thedillows.org>
Cc: Dave Jones <davej@redhat.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
Message-ID: <20070410071217.GA28899@aepfle.de>
References: <200704091007.58535.gene.heskett@gmail.com> <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr> <461A71FA.40900@zytor.com> <200704091538.44253.gene.heskett@gmail.com> <Pine.LNX.4.61.0704092334410.22295@yvahk01.tjqt.qr> <1176157330.4767.12.camel@dillow.idleaire.net> <20070410012754.GD1994@redhat.com> <1176169246.3193.2.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1176169246.3193.2.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, Dave Dillow wrote:

> It's not /dev he's backing up -- its /home, /usr, and others. GNU tar
> saves the device and inode numbers from the {,l}stat() call on each file
> and decides it is a new file if either number changes from run to run.

So fix tar to not do silly things.
Kernel major:minor numbers are not stable.
