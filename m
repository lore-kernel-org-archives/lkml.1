Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZAYK4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZAYK4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 05:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZAYK4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 05:56:33 -0500
Received: from lucidpixels.com ([75.144.35.66]:57391 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZAYK4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 05:56:33 -0500
Date: Sun, 25 Jan 2009 05:56:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-ide@vger.kernel.org
Subject: Switching from (deprecated) IDE driver -> SATA (PATA support)
Message-ID: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching (removing IDE support) in favor of the new PATA support 
under the SATA menu, is there any best practice/or method of knowing what 
the new root hdd will be upon reboot?

Example:
If I have 10 sata disks and 2 IDE disks on various cards/controllers, how 
do I know /dev/hda will become /dev/sda?  In one test on a system I have 
here, /dev/hda became /dev/sdb2 after reboot, not an issue if the box is 
local, but if the box is remote, how do you cope with this?  I ask now 
because some IDE drivers have been removed (nvidia I believe? in 2.6.28) 
and I cannot upgrade the kernel anymore unless I move to the 
PATA-supported SATA driver, but I have no idea what the root disk will be 
after a reboot and there is a high probability it will not come back after 
a reboot..

Justin.
