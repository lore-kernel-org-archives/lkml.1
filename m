Return-Path: <linux-kernel-owner+w=401wt.eu-S1761202AbYBAVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761202AbYBAVEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759283AbYBAVEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:04:05 -0500
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:31780 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759513AbYBAVD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:03:58 -0500
X-YMail-OSG: v0qHteIVM1ma1eCgLzSUi9xnCSX9VA2tnusUFLmBiK72Oqt3HSwGPaFkUFyrcGt9jY1th4gRbg--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 1 Feb 2008 15:01:47 -0600
From: serge@hallyn.com
To: Claude Frantz <claude@pc0312b.rz.unibw-muenchen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: permission denied while load kernel module using modprobe
Message-ID: <20080201210147.GA4734@vino.hallyn.com>
References: <47A2EAAF.90600@pc0312b.rz.unibw-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A2EAAF.90600@pc0312b.rz.unibw-muenchen.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Claude Frantz (claude@pc0312b.rz.unibw-muenchen.de):
> Hello !
>
> As user "root" I'm trying to load the ath_pci module from madwifi using
> the "modprobe" command, which is the recommanded way. But I get the
> following diag in the log:
>
> modprobe: WARNING: Could not open 
> '/lib/modules/2.6.23.8-34.fc7/net/ath_hal.ko': Permission denied modprobe: 
> WARNING: Could not open '/lib/modules/2.6.23.8-34.fc7/net/wlan.ko': 
> Permission denied modprobe: FATAL: Could not open 
> '/lib/modules/2.6.23.8-34.fc7/net/ath_rate_sample.ko': Permission denied 
> kernel: Error loading module "ath_rate_sample"
>
>
> Fedora 7 using kernel 2.6.23.8-34.fc7 as you can see above.
> All components in /lib/modules/2.6.23.8-34.fc7/net/ have the permission 
> -rwxr-xr-x and the directory itself has drwxr-xr-x 
> Which permission is wrong here ?
>
> Thanks a lot !
>
> Claude

Just a few possibilities,

1. could you do 'id -Z' and 'ls -lZ /lib/modules/2.6.23.8-34.fc7/net/'
   to see if selinux is involved?
2. most commonly on my own laptop i've seen this happen due to fs
   corruption...

-serge
