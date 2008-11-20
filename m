Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYKTUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYKTUiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYKTUiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:38:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:45654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbYKTUiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:38:01 -0500
From: "NeilBrown" <neilb@suse.de>
To: "Pawel Sikora" <pluto@agmk.net>
Date: Fri, 21 Nov 2008 07:37:53 +1100 (EST)
Message-ID: <396a0d3a836fa9fea13e7a255d098123.squirrel@neil.brown.name>
In-Reply-To: <5rbJChma.1227184936.9802590.pluto@agmk.net>
References: <5rbJChma.1227184936.9802590.pluto@agmk.net>
Subject: Re: [2.6.27.6] jfs on raid1 => attempt to access beyond end of 
     device.
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, November 20, 2008 11:42 pm, Pawe³ Sikora wrote:
> 20/11/2008, "Neil Brown" <neilb@suse.de> napisa³/a:

> failing raid1 device:
>
> # fsck.jfs -f -n -v /dev/md/0
> fsck.jfs version 1.1.13, 17-Jul-2008
> processing started: 11/20/2008 13.34.54
>
> /dev/md/0 is mounted and the file system is not type JFS.

Try
    grep md /proc/mounts
and
    fsck.ext3 -f -n /dev/md/0

I looked again at the logs and there is evidence that it is an
ext3 filesystem that was triggering those errors.
Maybe you never did a mkfs after creating the raid1???

NeilBrown


