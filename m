Return-Path: <linux-kernel-owner+w=401wt.eu-S936742AbYEURzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936742AbYEURzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936616AbYEURzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:55:24 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:48487 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936591AbYEURzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IZu4p+qgZ1w0WR29uKe4YE1vTvGjjZKrMDwXNGjUc0P9sRDKoXljZK7oS8lDU6+dR4Uf3r/tTobTQ/dnkTJEWnbPNAK0gxVgXLkb/Xoe3cXOo3i3PqtHrihZ6znSJbonHykcvEMSIOyYD2OSbOjIWh0myTw0En3cTqG9sTVuxGM=
Date: Wed, 21 May 2008 13:55:13 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno Pr??mont <bonbons@linux-vserver.org>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080521135345.ZZRA012@mailhub.coreip.homeip.net>
References: <200805162225.44284.bonbons@linux-vserver.org> <20080516163318.ZZRA012@mailhub.coreip.homeip.net> <200805162300.06027.bonbons@linux-vserver.org> <20080519114827.ZZRA012@mailhub.coreip.homeip.net> <20080519184501.38647a94@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519184501.38647a94@neptune.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

On Mon, May 19, 2008 at 06:45:01PM +0200, Bruno Pr??mont wrote:
> Hi Dmitry,
> 
> Please find attached dmesg output.
> 
> The suspend process looked somewhat like the following:
> - quick test of 
>     echo 1 > /sys/modules/i8042/parameters/debug
>   and disabled it again
>     echo 0 > /sys/modules/i8042/parameters/debug
> - exit X and rmmod usb-storage and a few other modules
>   (nfs, xfs and the like).
> - checked the extra keys (showkey) and enabled debug again
> - echo mem > /sys/power/state
> 
> Wait half a minute with laptop in S3
> 
> - hit enter to resume
> - wait a bit, as it takes too long help out with short
>   presses on power button (somehow it helps the HDD/CDROM
>   to resume), also pressed caps-lock when graphics were
>   resumed and cursor blinking (very slowly)
> - once userspace was awake again check extra keys with
>   showkeys
> - disabled input debug
> 
> I hope this is detailed enough.
> 
> List of patches applied to linux-2.6.25.4:
>   http://lkml.org/lkml/2008/5/16/430
>   http://lkml.org/lkml/2008/5/16/429
>   squashfs
> 

Question - does the problem happen if you dont have dritek extension
enabled (i.e. on unpatched kernel)?

-- 
Dmitry
