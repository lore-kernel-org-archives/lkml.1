Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZLFXFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZLFXFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbZLFXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:05:22 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:5437 "EHLO
	mx3.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757766AbZLFXFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:05:22 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B1C38B5.2060204@tremplin-utc.net>
Date: Mon, 07 Dec 2009 00:05:25 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: Zac Medico <zmedico@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>	 <4B055609.9030306@tremplin-utc.net>	 <4B1A53AE.9020707@tremplin-utc.net>	 <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>	 <4B1BDAA3.10601@gentoo.org> <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>
In-Reply-To: <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 06-12-09 17:35, Zeno Davatz schreef:
:
> Yes, thanks. That helped another step. I am getting the correct screen
> resolution after enabling that in the kernel as well. The boot [ok]
> messages of Gentoo are in a higher resolution now though. That is a
> good start.
>
> But after my X starts I get a black screen with a
>
> -
>
> in the top left corner. They keyboard also does not work. May be an
> X.org config problem.
>
I've got similar behaviour here if psb is loaded before the X server 
starts (aka there is a framebuffer). If the console is just ascii (no 
vga=... argument on the kernel boot line, and no "modprobe psb"), then X 
starts fine.

Eric
