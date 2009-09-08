Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZIHW0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZIHW0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZIHW0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:26:37 -0400
Received: from outbound-mail-112.bluehost.com ([69.89.24.2]:39604 "HELO
	outbound-mail-112.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752503AbZIHW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:26:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Hy32hrKcbKVWe9OPE4hKSni2fyh1u/wKvM88s7EICaxE4VJWzmy8b8GQpEbTbkvw7odrzVVMe6q5coD+fJhmLUDjUzWy3XBzTdZm+1EnJQ3GU55AkoM4c5CeIruEuDPW;
Date: Tue, 8 Sep 2009 15:26:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@osdl.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after
 2.6.31-rc8-git1, DVI connector ok
Message-ID: <20090908152636.701feffb@jbarnes-g45>
In-Reply-To: <4AA6D858.6040505@t-online.de>
References: <4AA6D858.6040505@t-online.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing the intel-gfx list.

On Wed, 09 Sep 2009 00:19:04 +0200
Knut Petersen <Knut_Petersen@t-online.de> wrote:

> Hi everybody!
> 
> During the release cycle of the 2.6.31-rc* kernels KMS started to work
> on my computer.
> 
> Booting with a monitor attached to both the VAG and the DVI
> connectors, kernel 2.6.31-rc8-git1
> detects both monitors correctly and sets the native video mode.
> 
> Booting the same configuration with kernel 2.6.31-rc8-git2 ...
> -rc9-git1 gives a different result:
> the DVI-attached monitor is still working perfectly, the VGA-attached
> monitor does not detect a
> valid video signal and switches off.
> 
> Hardware: AOpen i915GMm-hfs,  Pentium-M 1.86 MHz,  2GB RAM
> The Aopen i915GMm-hfs is a  desktop board with a mobile Chipset:
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
> Express Processor to DRAM Controller (rev 04)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile
> 915GM/GMS/910GML Express Graphics Controller (rev 04)
> 00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML
> Express Graphics Controller (rev 04)
> 
> Config: AGP/DRM/I915 all compiled into kernel, KMS enabled.
> 
> Log_Broken contains the result of "cat boot.msg | grep -i drm" of a
> boot with 2.6.31-rc8-git2,
> Log_OK contains the result of "cat boot.msg | grep -i drm" of a boot
> with 2.6.31-rc8-git1
> 
> As a black monitor is not a nice gift I think this should be fixed
> before the final release of 2.6.31.
> 
> cu,
>  Knut


-- 
Jesse Barnes, Intel Open Source Technology Center
