Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYJFPlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYJFPlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYJFPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:41:29 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.10.160]:59832 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbYJFPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:41:28 -0400
Message-ID: <48EA31A4.6080903@cmu.edu>
Date: Mon, 06 Oct 2008 11:41:24 -0400
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to link to hrtimers in the kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have modified drivers/usb/core/devio.c to use hrtimer_nanosleep(), and 
have included linux/hrtimer.h with it.

But now I am having trouble linking, I get:
ERROR: "hrtimer_nanosleep" [drivers/usb/core/usbcore.ko] undefined!

How do I properly link to the hrtimer library?

Thanks!
George
