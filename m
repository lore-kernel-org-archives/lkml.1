Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYFHSjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYFHSjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYFHSjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:39:31 -0400
Received: from tango.0pointer.de ([85.214.72.216]:44160 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbYFHSjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:39:31 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2008 14:39:30 EDT
Date: Sun, 8 Jun 2008 20:32:55 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook
	Pros
Message-ID: <20080608183255.GB3580@tango.0pointer.de>
References: <20080607025436.GB24254@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607025436.GB24254@srcf.ucam.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07.06.08 03:54, Matthew Garrett (mjg59@srcf.ucam.org) wrote:

> Lennart - as far as I could tell from your description, the DMI 
> autoloading code for this should be correct. However, it's not working 
> for me on F9. Have I missed something, or does it just not work there?

It should be pretty easy to figure out the right string for
DMI autoloading. Just do a cat /sys/class/dmi/id/modalias and replace the
part of the string you consider not very useful for identifying the
machine with (dates, version numbers, empty strings, 0123456
rubbish data, ...) with an asterisk.

Looking at those strings included in your patch they look pretty much
correct, but since I don't have access to a Mac I cannot really check
this.

It's udev's job to match the modalias strings of your driver module
with the modalias string from /sys/class/dmi/id/modalias. You can
retrigger this matching by doing something like "echo 1 >
/sys/class/dmi/id/uevent" or suchlike, but I don't remember the
details.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
