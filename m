Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbZBMI5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbZBMI5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 03:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZBMI5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 03:57:10 -0500
Received: from fallback.us4.outblaze.com ([205.158.62.120]:42824 "EHLO
	fallback.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZBMI5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 03:57:10 -0500
X-Greylist: delayed 1391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 03:57:09 EST
X-OB-Received: from unknown (205.158.62.131)
  by wfilter3.us4.outblaze.com; 13 Feb 2009 08:33:57 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Erin Teran" <erin_teran@linuxmail.org>
To: linux-kernel@vger.kernel.org
Cc: postme1@gmx.net, "USB list" <linux-usb@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>
Date: Fri, 13 Feb 2009 16:33:57 +0800
Subject: Re: USB gadget problem with close of a gadgetfs device
X-Originating-Ip: 217.89.99.70
X-Originating-Server: ws5-1.us4.outblaze.com
X-Ob-Auth: erin_teran:linuxmail.org@linuxmail.org
Message-Id: <20090213083357.7F3B9446D8@ws5-1.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I couldnt find an answer to my question in the archive or the kernel documentation.
I'm new to Linux and the LKML so please point me in the right direction if the question is misplaced here.

I have a problem while using driver/usb/gadget/gadgetfs
Sometimes I cant reopen the device propperly. I get an -EBUSY.
Using atom_read(&fd->f_count) and printk() in inode.c dev_open I found out that the count is 1 when the failure occurs.
I checked several times if all fd I opened where closed, and they are.

Therefore I'm kinda lost here:
Q: Is f_count only increased after the dev_open returned success?
Q: Does poll() - which I use in my app - duplicate a fd and increase f_count?
Q: Is there a known issue with poll() and the pthread lib?
Q: What happens when I terminate a thread - pthread_cancel() - which is currently in a poll() call?

Thank you,
Erin



=
Listen & Play Mp3 Songs Completely Free
Listen & Play Online Mp3 Song Completely Free MUSIC ARTICLES AND MORE.
http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=f51d2a53b77b9b8d7c5fcbd5e19676ba


-- 
Powered by Outblaze
