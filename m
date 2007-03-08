Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXCHUBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXCHUBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXCHUBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:01:39 -0500
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:39533 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933258AbXCHUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:01:38 -0500
From: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
To: Jari Ruusu <jariruusu@users.sourceforge.net>
Date: Fri, 9 Mar 2007 07:01:30 +1100 (EST)
X-X-Sender: kven709@williams.orchestra.cse.unsw.EDU.AU
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop 
 devicethrough mmap
In-Reply-To: <45F05FEB.9AED3D31@users.sourceforge.net>
Message-ID: <Pine.LNX.4.64.0703090647470.20037@williams.orchestra.cse.unsw.EDU.AU>
References: <Pine.LNX.4.64.0703081342000.21734@williams.orchestra.cse.unsw.EDU.AU>
 <45F05FEB.9AED3D31@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Mar 2007, Jari Ruusu wrote:

> Kandan Venkataraman wrote:
>> All comments have been taken care of.
>
> Your patch still does not do conversions of existing user space visible
> 'struct loop_info64' which is pretty much cast in stone. Blindly overwriting
> larger structure over smaller user space buffer of existing userspace
> binaries is the wrong way to do this.

Which of the two options below would be the best way 
to get around this problem.

i)A new ioctl call to set/unset lo_track_pgwrite.

ii) Create 'struct loop_info64_v2' with 
lo_track_pgwrite in it and two new ioctls LOOP_SET_STATUS64_V2
and LOOP_GET_STATUS64_V2.

Either way 'struct loop_info64' would be left untouched.

Please comment.





>
> There was a time when folks at least pretended that breaking user space ABI
> was not tolerable.
>
> -- 
> Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
>
