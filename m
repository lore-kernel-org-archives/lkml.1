Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab0BKUov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:44:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53526 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab0BKUot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:44:49 -0500
Date: Thu, 11 Feb 2010 20:44:41 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: nicolas@boichat.ch, felipe_alfaro@linuxmail.org,
       Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
Message-ID: <20100211204441.GA5956@srcf.ucam.org>
References: <1265920725.7103.7.camel@no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265920725.7103.7.camel@no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:38:45PM +0100, Soeren Sonnenburg wrote:
> Dear all,
> 
> I am booting a MacBookPro5,3 using elilo and efifb. Now I'd like to use
> pommed to control display brightness (which won't work). Digging around
> in mbp_nvidia_bl.c I figured out that tries to control the geforce 9600M
> instead of the currently active geforece 9400m

So, first of all, use nouveau instead. But moving on...

> 02:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600M GT] (rev a1)
> 03:00.0 VGA compatible controller: nVidia Corporation C79 [GeForce 9400M] (rev b1)
> 
> Does anyone have an idea which bytes to tweak to change brightness
> levels for the 9400? Seems like 0x52f does not work - at least
> setpci -s 03:00.0 0x52f.B=10 fails...

Those are mmio registers, not PCI config ones. You won't be able to 
change them with setpci.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
