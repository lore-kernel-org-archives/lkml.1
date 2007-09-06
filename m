Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXIFMHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXIFMHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbXIFMGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:06:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45398 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbXIFMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:06:45 -0400
Date: Thu, 6 Sep 2007 14:06:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
In-Reply-To: <46D9D587.9020605@zytor.com>
Message-ID: <Pine.LNX.4.64.0709061404120.25942@fbirervta.pbzchgretzou.qr>
References: <20070831201820.GF31970@nostromo.devel.redhat.com>
 <46D9D587.9020605@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 1 2007 22:11, H. Peter Anvin wrote:
> Bill Nottingham wrote:
>> As of now, the kernel defaults to non-unicode and XLATE for the keyboard.
>> We've been changing this in Fedora, but that requires patching the defaults
>> in the kernel.
>> 
>> The attached introduces CONFIG_VT_UNICODE, which sets the console in unicode
>> mode by default on boot, including both the virtual terminal and the keyboard
>> driver.
>> 
>> Signed-off-by: Bill Nottingham <notting@redhat.com>
>
> Wasn't there a patch floating around about this a couple of months ago, which
> also let you set the system-wide default via sysctl?

sysfs, and you were on the discussion (your idea won, basically....)
And the way I see it, it got merged.
Commit 042f10ec6533e53181284c96d22ae051e49ac707

As I further see it, this CONFIG_VT_UNICODE patch defines the 
starting value for the default.

E.g. CONFIG_VT_UNICODE=y, you start with utf8, and can, at will, at 
runtime, change it. CONFIG_VT_UNICODE=n, you start with 8bit, and can, 
at will, at runtime, too, change it ;-)




	Jan
-- 
