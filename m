Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXEXRxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXEXRxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXEXRxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:53:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45064 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXEXRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:53:07 -0400
Date: Thu, 24 May 2007 10:53:07 -0700
From: Greg KH <greg@kroah.com>
To: art@usfltd.com
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
Message-ID: <20070524175307.GA18940@kroah.com>
References: <20070517190058.w2oyxzf9wko4w8k8@67.106.77.50>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517190058.w2oyxzf9wko4w8k8@67.106.77.50>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 07:00:58PM -0500, art@usfltd.com wrote:
>  greg
> 
>  and part of /etc/udev/rules.d/60-libsane.rules
> 
>  ...
>  ACTION!="add", GOTO="libsane_rules_end"
>  SUBSYSTEM!="usb_device", GOTO="libsane_rules_end"
> 
>  # Hewlett-Packard ScanJet 4100C
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0101", SYMLINK+="scanner-%k"
>  # Hewlett-Packard Photosmart S20 (C5101A) | Hewlett-Packard Photosmart S20xi 
>  (C7150A)
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0102", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 4200C | Hewlett-Packard ScanJet 4200Cxi | 
>  Hewlett-Packard ScanJet 4200Cse
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0105", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 6200C | Hewlett-Packard ScanJet 6250C
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0201", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 3300c
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0205", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 4300c
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0305", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 5200C
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0401", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 3400c
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0405", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 2100C
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0505", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 6300C | Hewlett-Packard ScanJet 6350C | 
>  Hewlett-Packard ScanJet 6390C
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0601", SYMLINK+="scanner-%k"
>  # Hewlett-Packard ScanJet 2200C
>  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0605", SYMLINK+="scanner-%k"
> 
>  ...
>  # Dell 1600n
>  SYSFS{idVendor}=="413c", SYSFS{idProduct}=="5250", SYMLINK+="scanner-%k"
> 
>  LABEL="libsane_rules_end"


I don't see anything odd there at all.

Can you run 'git bisect' to try to narrow down to the patch that caused
the problem?

thanks,

greg k-h
