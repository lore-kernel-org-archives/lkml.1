Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbZEVSaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbZEVSaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZEVS35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:29:57 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:50264 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZEVS35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:29:57 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 14:29:56 EDT
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905221149030.3006-100000@iolanthe.rowland.org>
References: <ac3eb2510905220821n629314c3tb113802f52abc67c@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905221149030.3006-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 22 May 2009 20:24:15 +0200
Message-ID: <ac3eb2510905221124y412dc3bdp65ad1b74373175a9@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 17:54, Alan Stern <stern@rowland.harvard.edu> wrote:

>> Would releasing the "lock" trigger a kernel-driver-binding call?
>
> No.  If the lock owner wants to bind kernel drivers, it can use the
> existing API in libusb after releasing the lock.  This might cause
> problems if the owning process terminates abnormally, but I think we
> can live with that.
>
>> The lock will always lock all devices of a specific hub?
>
> The idea is that there will be one lock file per port.  So for example,
> a hub device with four ports might contain inside its sysfs device
> directory: ports/1, ..., ports/4.

Sounds both good to me.

Kay
