Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYJaBEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYJaBEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYJaBDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:03:55 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46399 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYJaBDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:03:54 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=TC2-7eed_BAjH0eavacA:9 a=KIw94Sby9YOlwjqgB0cA:7 a=YcbyGDpBKrGSrgsiwu_X2Bso0RAA:4 a=lwYQcFBbX3oA:10 a=_RkS-PBGOisA:10
Message-ID: <490A5977.8090705@shaw.ca>
Date: Thu, 30 Oct 2008 19:03:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.2 USB reset/IO Error problem when high load on ICH9 USB
References: <fa.PPRUdlhLAQMsAcsErf8qHTGwTPQ@ifi.uio.no>
In-Reply-To: <fa.PPRUdlhLAQMsAcsErf8qHTGwTPQ@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> Hello..
> 
> I had to write an image to some usb flash drives, more specifically, 4GB
> kingston datatraveler sticks, and i figured, instead of doing just 1 at
> a time, i may aswell do 4, so i plugged in 4, and started 4 dd's of the
> images, to sdc, sdd, sde, sdf. However, i got usb disconnects and IO
> error messages from the kernel, these are at end of message. I had
> previously done ~5 writes of images to 5 other flash disks with no
> problem, but when i tried the next batch, those 4, it gave these errors.
> I killed the dd's, pulled them all out, and put in 1 at a time, and it
> worked perfectly.
> 
> unfortunately the first kernel messages have been flooded away. If you
> need .config and/or the boot kernel messages, i can reboot and get it.

It seems suspicious that only the sde one (with address 6) seems to be 
having problems. Are you sure that drive wasn't faulty or somehow not 
plugged in properly?
