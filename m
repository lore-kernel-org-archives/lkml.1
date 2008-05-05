Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYEEIPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYEEIPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbYEEIPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:15:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:43389 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbYEEIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:15:08 -0400
Subject: Re: 2.6.26-rc1-git1 -- trying to get vblank count for disabled
	pipe 0
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       DRI for Linux <dri-devel@lists.sourceforge.net>
In-Reply-To: <481E5EE6.6090503@gmail.com>
References: <481E5EE6.6090503@gmail.com>
Content-Type: text/plain; charset=utf-8
Organization: Tungsten Graphics
Date: Mon, 05 May 2008 10:15:02 +0200
Message-Id: <1209975302.26326.263.camel@thor.sulgenrain.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-04 at 21:12 -0400, Miles Lane wrote:
> When I boot this kernel, everything seems okay, but after I leave the
> machine for 30 minutes or so, I come back and find the machine locked
> up.  

Define 'locked up'. Can you ping it? Can you log in via ssh? Is the X
server still alive? Where is it stuck? ...


> When I checked my log file after rebooting, I find the log filled with "trying to get vblank count for disabled pipe 0".

[...]

> May  4 14:40:44 whirligig kernel: [   47.544109] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x12, stream=0x5, channel=0, format=0x4011
> May  4 14:40:46 whirligig kernel: [   48.850489] trying to get vblank count for disabled pipe 0
> May  4 14:40:46 whirligig kernel: [   48.897990] trying to get vblank count for disabled pipe 0
> May  4 14:40:46 whirligig kernel: [   48.941691] trying to get vblank count for disabled pipe 0
> May  4 14:40:46 whirligig kernel: [   49.003556] trying to get vblank count for disabled pipe 0
> May  4 14:40:46 whirligig kernel: [   49.147880] trying to get vblank count for disabled pipe 0
> May  4 14:40:47 whirligig kernel: [   50.528654] trying to get vblank count for disabled pipe 0
> [...]
> May  4 15:36:23 whirligig kernel: [ 3404.847515] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0xe
> May  4 16:06:53 whirligig kernel: [ 5241.488711] trying to get vblank count for disabled pipe 1
> May  4 16:06:53 whirligig kernel: [ 5241.488748] trying to get vblank count for disabled pipe 1
> May  4 16:06:53 whirligig kernel: [ 5241.496130] trying to get vblank count for disabled pipe 1
> May  4 16:06:53 whirligig kernel: [ 5241.516053] trying to get vblank
> count for disabled pipe 1

Note that some of these are for pipe 1 as well as pipe 0. Does the
problem only occur for one of them?

Do you have any GL apps running when this happens?


-- 
Earthling Michel Dänzer           |          http://tungstengraphics.com
Libre software enthusiast         |          Debian, X and DRI developer

