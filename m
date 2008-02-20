Return-Path: <linux-kernel-owner+w=401wt.eu-S935904AbYBTQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935904AbYBTQku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934781AbYBTQbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:31:20 -0500
Received: from lazybastard.de ([212.112.238.170]:36294 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777AbYBTQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:31:17 -0500
Date: Wed, 20 Feb 2008 17:30:42 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephane Chazelas <stephane.chazelas@emerson.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <20080220163042.GC5539@lazybastard.org>
References: <chaz20080212134751.GI30304@artesyncp.com> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org> <200802192333.39707.arnd@arndb.de> <chaz20080220144339.GK4539@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <chaz20080220144339.GK4539@artesyncp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 February 2008 14:43:39 +0000, Stephane Chazelas wrote:
> 
> note that for "loop", you have /dev/loop0, /dev/loop1... which
> makes it a pain to handle
> 
> For block2mtd, you don't need several device files in /dev, you
> only need one to pass ioctls down to create mtd devices.
> 
> That may end up creating new /dev devices via mtdblock or
> mtdblock_ro for instance.
> 
> So I'm not sure reusing the "loop" ioctls is a good idea.

/me notes that you dislike both existing interfaces and would prefer a
third.  How likely is it that you will still like the new interface two
years down the road?  How likely is it that everyone else will agree
with you?

In the end, a painful interface is still less painful than a choice of
several incompatible ones.  I used to think different and have burned my
fingers often enough to learn the lesson. :)

Jörn

-- 
Mac is for working,
Linux is for Networking,
Windows is for Solitaire!
-- stolen from dc
