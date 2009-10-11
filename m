Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZJKAEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZJKAEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 20:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZJKAEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 20:04:43 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:14494 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZJKAEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 20:04:42 -0400
X-Spam-Flag: NO
X-Spam-Score: -11.374
Message-ID: <4AD120F2.3020606@tremplin-utc.net>
Date: Sun, 11 Oct 2009 02:04:02 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-input@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [REGRESSION] "bind" a device to a driver doesn't not work anymore
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After a suspend, I used to do this (to get the PS2 keyboard working 
again), and it used to work fine:
echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind ; sleep 1 ; 
echo -n "i8042" > /sys/bus/platform/drivers/i8042/bind

Unfortunately since 2.6.32-rc1, the unbind works fine, but the bind 
returns a "no such device" error now (and the binding is not done). 
After that, additional unbinds also report the error. I think 2.6.31 
worked fine. Any idea what's going wrong?

Thanks,
Eric
