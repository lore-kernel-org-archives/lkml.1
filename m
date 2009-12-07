Return-Path: <linux-kernel-owner+w=401wt.eu-S934948AbZLGJvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948AbZLGJvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934902AbZLGJvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:51:45 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:20666 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934897AbZLGJvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:51:44 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B1CD029.3080503@tremplin-utc.net>
Date: Mon, 07 Dec 2009 10:51:37 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
Cc: Zac Medico <zmedico@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>	 <4B055609.9030306@tremplin-utc.net>	 <4B1A53AE.9020707@tremplin-utc.net>	 <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>	 <4B1BDAA3.10601@gentoo.org>	 <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>	 <4B1C38B5.2060204@tremplin-utc.net> <40a4ed590912070143j231e07b6uafd04d0f2ee15dca@mail.gmail.com>
In-Reply-To: <40a4ed590912070143j231e07b6uafd04d0f2ee15dca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-12-09 10:43, Zeno Davatz schreef:
> On Mon, Dec 7, 2009 at 12:05 AM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
>> Op 06-12-09 17:35, Zeno Davatz schreef:
>> :
>>> Yes, thanks. That helped another step. I am getting the correct screen
>>> resolution after enabling that in the kernel as well. The boot [ok]
>>> messages of Gentoo are in a higher resolution now though. That is a
>>> good start.
>>>
>>> But after my X starts I get a black screen with a
>>>
>>> -
>>>
>>> in the top left corner. They keyboard also does not work. May be an
>>> X.org config problem.
>>>
>> I've got similar behaviour here if psb is loaded before the X server starts
>> (aka there is a framebuffer). If the console is just ascii (no vga=...
>> argument on the kernel boot line, and no "modprobe psb"), then X starts
>> fine.
> 
> What are the exact options that you are using for "no vga"?
> 
> My terminal seems to automatically load "psb". I have no modprobe
> loading "psb" explicitly.
> 
Well, I don't know exactly how it works, probably it's part of the
initrd. Here, on Mandriva, if I remove the "vga" argument, it
automatically stays in ascii mode.

You could use lsinitrd to check your initrd.
Eric
