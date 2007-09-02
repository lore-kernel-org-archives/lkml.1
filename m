Return-Path: <linux-kernel-owner+w=401wt.eu-S966090AbXIBLzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966090AbXIBLzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964904AbXIBLzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:55:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965477AbXIBLzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:55:19 -0400
Date: Sun, 2 Sep 2007 04:54:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org, contact@i-nz.net,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: Master volume control broken (regression against 2.6.22)
Message-Id: <20070902045432.18668762.akpm@linux-foundation.org>
In-Reply-To: <46C6CAFC.1020709@m3y3r.de>
References: <46C6CAFC.1020709@m3y3r.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 18 Aug 2007 12:33:32 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:
> This commit broke my master volume control:
> 
> 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1 is first bad commit
> commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
> Author: Ivan N. Zlatev <contact@i-nz.net>
> Date:   Tue May 29 16:03:00 2007 +0200
> 
>     [ALSA] hda-codec - Fix pin configs for Intel Macs
> 
>     * adds the pinconfigs for all 5 Apple boards and 14 Subsystem IDs
>       (support for possibly all iMac, Mac, MacMini etc etc)
>     * adds 'intel-mac-v1' to v5 models which replace the current
>     * reflects changes in Alsa-Configuration.txt
> 
>     Signed-off-by: Ivan N. Zlatev <contact@i-nz.net>
>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>     Signed-off-by: Jaroslav Kysela <perex@suse.cz>
> 
> :040000 040000 16c8f8d66545ab0cb6dfc44f3c92ff9ad0b53658
> e3e9a07b1a3a0d68c6870f7a111ca817a89ce24b M      Documentation
> :040000 040000 b49d5f64d27e248f08d6fad8b1ff4f03c182f46a
> b4a361b5cacc96d139572b592bbcba3504c1f9c5 M      sound
> 
> I no longer can use my fancy multimedia control keys :-(
> 

You mean that 2.6.22 works OK and 2.6.23-rcX does not?
