Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYIVFg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYIVFg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 01:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYIVFgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 01:36:18 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.10.159]:40716 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYIVFgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 01:36:18 -0400
X-Greylist: delayed 1061 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 01:36:17 EDT
Message-ID: <48D72AAD.3000805@cmu.edu>
Date: Mon, 22 Sep 2008 01:18:37 -0400
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: printing current system time from kernel space
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please CC me on any responses.

I am looking to measure the latency of USB data between kernel space and 
user space.  The user space driver uses a URB to get data from the 
device to the kernel and finally to user space.

To measure this latency, I was thinking of printing the current system 
time when a read occurs/succeeds in drivers/usb/core/devio.c at the 
function usbdev_read(), and then again in user space when the URB 
succeeds in reading.  Then, I could subtract the two times to get the 
latency.

I spent some time googling, but could not find out how or if it is 
possible to read the current system time in kernel space.  I could 
insert a printk() somewhere in usbdev_read() then.

If it is not possible to read the current system time, is there some 
other shared clock between kernel and user space that I could use for this?

Thank you!
George
