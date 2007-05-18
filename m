Return-Path: <linux-kernel-owner+w=401wt.eu-S1762484AbXERACU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484AbXERACU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbXERACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:02:10 -0400
Received: from mail4.webhostingstar.com ([67.106.77.50]:49652 "HELO
	mail4.webhostingstar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761198AbXERACJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:02:09 -0400
Message-ID: <20070517190058.w2oyxzf9wko4w8k8@67.106.77.50>
Date: Thu, 17 May 2007 19:00:58 -0500
From: art@usfltd.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, greg@kroah.com
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

greg

and part of /etc/udev/rules.d/60-libsane.rules

...
ACTION!="add", GOTO="libsane_rules_end"
SUBSYSTEM!="usb_device", GOTO="libsane_rules_end"

# Hewlett-Packard ScanJet 4100C
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0101", SYMLINK+="scanner-%k"
# Hewlett-Packard Photosmart S20 (C5101A) | Hewlett-Packard Photosmart  
S20xi (C7150A)
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0102", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 4200C | Hewlett-Packard ScanJet 4200Cxi |  
Hewlett-Packard ScanJet 4200Cse
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0105", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 6200C | Hewlett-Packard ScanJet 6250C
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0201", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 3300c
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0205", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 4300c
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0305", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 5200C
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0401", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 3400c
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0405", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 2100C
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0505", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 6300C | Hewlett-Packard ScanJet 6350C |  
Hewlett-Packard ScanJet 6390C
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0601", SYMLINK+="scanner-%k"
# Hewlett-Packard ScanJet 2200C
SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0605", SYMLINK+="scanner-%k"

...
# Dell 1600n
SYSFS{idVendor}=="413c", SYSFS{idProduct}=="5250", SYMLINK+="scanner-%k"

LABEL="libsane_rules_end"


xboom

