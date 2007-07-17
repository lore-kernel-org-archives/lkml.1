Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXGQEMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXGQEMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXGQEMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:12:25 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:52146 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXGQEMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:12:25 -0400
Date: Tue, 17 Jul 2007 05:12:23 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] more drm patches for 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707162055380.19166@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707170511230.22470@skynet.skynet.ie>
References: <Pine.LNX.4.64.0707170212310.2500@skynet.skynet.ie>
 <alpine.LFD.0.999.0707162055380.19166@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I really think this or the previous tree is buggy.

I've got this to reproduce on my machine, this code came from DRM git and 
has been okay in there for a few weeks, I'll do some digging it may be 
something to do with the idr + context/drawable code..

Dave.

>
> Trying to start any 3D client just hangs my Evo laptop hard. It's a Radeon
> Mobility 7500 behind a ICH4 southbridge, so standard Intel AGP, and not
> anything very usual gfx-chipwise either.
>
> I don't have netconsole or anything, so I'm mixxing any potential oops,
> and I guess I should try that next, but not today. I'm hoping this is
> something obvious and/or already known, since my setup certainly isn't
> unusual.
>
> 			Linus
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by DB2 Express
> Download DB2 Express C - the FREE version of DB2 express and take
> control of your XML. No limits. Just data. Click to get it now.
> http://sourceforge.net/powerbar/db2/
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>

-- 
David Airlie, Software Engineer
http://www.skynet.ie/~airlied / airlied at skynet.ie
Linux kernel - DRI, VAX / pam_smb / ILUG

