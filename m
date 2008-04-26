Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYDZXS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYDZXS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYDZXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:18:19 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:49786 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYDZXST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:18:19 -0400
X-Authority-Analysis: v=1.0 c=1 a=CER7YOeXyIkWw2prI98A:9
 a=h1g74xOfWuXMSjmQcvS58HYKyxAA:4 a=50e4U0PicR4A:10
From: Dmitry Torokhov <dtor-oss@comcast.net>
To: Stas Sergeev <stsp@aknet.ru>
Subject: Re: [patch] pcspkr: fix dependancies
Date: Sat, 26 Apr 2008 19:18:14 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
References: <4813476A.7000705@aknet.ru>
In-Reply-To: <4813476A.7000705@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804261918.14711.dtor-oss@comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stas,

On Saturday 26 April 2008, Stas Sergeev wrote:
> Hello.
> 
> linux-2.6.25 has the strange dependancies
> for pc-speaker, which prevents snd-pcsp
> from working.
> Namely, the platform device (created in
> arch/x86/kernel/pcspeaker.c) depends on
> the platform driver (CONFIG_INPUT_PCSPKR).
> I wonder if it is a good practice to make
> the platform device to depend on the driver,
> I guess it is not.
> 
> The attached patch reverses that.
> It adds the config option for the pcspkr
> platform device and makes the platform
> drivers to depend on that.
> This allows snd-pcsp to work at least in
> some configurations.
> 

No, not another config option please. Either make pcspkr platform
device be created unconditionally or if either pcspkr or snd-pcsp
is selected. 

-- 
Dmitry
