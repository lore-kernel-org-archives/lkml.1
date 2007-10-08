Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbXJHQTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbXJHQTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 12:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbXJHQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 12:18:54 -0400
Received: from ev1s-64-246-26-5.ev1servers.net ([64.246.26.5]:36943 "EHLO
	hitbase.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbXJHQSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:18:53 -0400
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Oct 2007 12:18:53 EDT
Message-ID: <054301c809c4$bc5bc530$a5ac83c3@dmitryd3a1165b>
From: "Dmitry Sychov" <accelware@accelware.com>
To: <linux-kernel@vger.kernel.org>
Subject: Buffered filesystem AIO status?
Date: Mon, 8 Oct 2007 20:03:06 +0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="koi8-r";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'am the developer of the subset of Linux API on windows.

Pretty much all system calls were "wrapped" up to the the latest
kernel native AIO support.

While compiling/running test program natively on Linux
(2.6.18-8.1.10.el5)
I've got hit by undocumented limitations of AIO system:

* aio support only for files opened with O_DIRECT
* alignment issues/data sizes for O_DIRECT-opened files
* special cases like extending file, reading meatadata
  also seem to block.

I was glad to find out that a work was done to overcome this:
http://www.kernel.org/pub/linux/kernel/people/suparna/aio/


The only thing that concerns me is that the 2007 year
patches are all against release candidates, and the latest
one was released more than 7 months ago.

So I'am looking for the status update.

Any current plans/interest to finally include this in latest
trees?

Or this was taken down in favour of servlets?

Regards,

--
dmitry
