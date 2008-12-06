Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYLFPsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYLFPsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 10:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbYLFPrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 10:47:53 -0500
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1808 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbYLFPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 10:47:52 -0500
Message-ID: <493A9EA6.7050808@xs4all.nl>
Date: Sat, 06 Dec 2008 16:47:50 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: ITE: Found unknown chip with ID 0x8720
References: <493A8E3E.6080603@xs4all.nl>
In-Reply-To: <493A8E3E.6080603@xs4all.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Hello,
> 
> Just installed a Gigabyte MA770-DS3 board: 
> http://www.gigabyte.com.tw/Products/Motherboard/Products_Spec.aspx?ProductID=2722 
> 
> 
> It has an iTE IT8718 chip according to this url.
> 
> But:
> sensors-detect says:
> Trying family `ITE'...                                      Yes
> Found unknown chip with ID 0x8720
> 
> And:
> modprobe it87 says no such device although 8718F is supported.
> 
> Is this a known issue?

I got an answer from Jean Delvare:
Try a more recent version of sensors-detect:

svn export 
http://lm-sensors.org/svn/lm-sensors/branches/lm-sensors-3.0.0/prog/detect/sensors-detect

It'll tell you you have an IT8720F chip. Supported by the it87 driver
after applying this patch:
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-hwmon/hwmon-it87-add-it8720f-support.patch


This appears to work fine now!

Udo
