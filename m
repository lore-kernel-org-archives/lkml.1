Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZAWPrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZAWPrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbZAWPrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:47:15 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:47753 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbZAWPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:47:13 -0500
Message-ID: <4979E67D.5040604@turknet.net.tr>
Date: Fri, 23 Jan 2009 17:47:09 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Matt Carlson <mcarlson@broadcom.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] tg3 module problem on Linux-2.6.29-rc1-2
References: <49771D65.3090205@turknet.net.tr> <20090121152818.GA3438@x200.localdomain> <497870A3.4070200@turknet.net.tr> <20090122203252.GA3258@xw6200.broadcom.net>
In-Reply-To: <20090122203252.GA3258@xw6200.broadcom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2009 15:47:10.0017 (UTC) FILETIME=[DA122B10:01C97D71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Carlson wrote:
> The error message is coming from the
> /usr/share/initramfs-tools/hook-functions script.  You are right that
> the script does not look at the config file for
> CONFIG_FIRMWARE_IN_KERNEL=y, but I'm not sure if it should or not.
>
> The script uses the command 'modinfo -F firmware tg3' to determine
> whether or not it should include firmware images in the initrd.  The
> modinfo command simply inspects the tg3.ko module binary reports if the
> module makes any firmware requests.  Obviously this isn't the complete
> picture.
>
> Somewhere in this process, the script or modinfo needs to find out if
> the kernel has firmware images builtin.  How this gets accomplished is
> probably best left to the script maintainers.
>
>   
Yep, you are right. It looks to me a bit like standard kernel compile 
process' fault/bug.
Because all the previous kernel versions prior to 2.6.29-rc1/2 work 
flawlessly.

