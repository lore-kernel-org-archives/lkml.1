Return-Path: <linux-kernel-owner+w=401wt.eu-S1030925AbXDSK1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030925AbXDSK1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 06:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993226AbXDSK1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 06:27:22 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:59791 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030925AbXDSK1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 06:27:21 -0400
Message-ID: <46274407.8010602@panasas.com>
Date: Thu, 19 Apr 2007 13:27:19 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wrong free clusters count on FAT32
References: <20070419085750.GA2833@DervishD>
In-Reply-To: <20070419085750.GA2833@DervishD>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Apr 2007 10:27:20.0227 (UTC) FILETIME=[4F9FD730:01C7826D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD wrote:
>     Hi all :)
> 
>     I have a portable device with a FAT32 formatted hard disk in it, and
> everytime I delete a file in the device *using the device itself to do
> it* the device increases its count of free space and if I plug the
> device in a Windows system, Windows agrees on the free space. Linux
> doesn't. Linux believes that the files are still there ocuppying space,
> and I have to run fsck.vfat to fix the problem.
> 
>     As far as I've seen, the device is probably not updating correctly
> the list of free clusters, but it doesn't seem to worry about it,
> neither does Windows. So my question is: is there any way of making
> Linux "bug compatible" with Windows? If Windows itself don't worry about
> the free cluster count and computes the free space in some other way,
> then it can be done. I haven't seen anything in mount(8) neither
> googling.
> 
>     Apart from not using the device itself to delete files (and probably
> not using Windows for that, either) and to run fsck.vfat now and then,
> is anything I can do to avoid this problem?
> 
>     Thanks a lot in advance :)
> 
>     Raúl Núñez de Arenas Coronado
> 
Not that I know how to fix it. But have you tried running chkdsk on a
device deleted files in windows. Just that I know, that windows would
silently ignore fat errors and will only report them in chkdsk.

Deleting files in windows works fine. There is no problems with it and
windows updates everything. I do that all the time.
(I would even theorize that if you delete files on the device and than farther
delete more files on windows, than windows will fix the problem on the fly)
So it is "bug compatible" with the device, and error recovery
compatible with windows.

Boaz
