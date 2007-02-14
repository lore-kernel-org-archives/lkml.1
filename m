Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbXBNI5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbXBNI5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbXBNI5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:57:49 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62381 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502AbXBNI5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:57:48 -0500
Date: Wed, 14 Feb 2007 09:57:46 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: undefined symbol 'PS3_PS3AV'
In-Reply-To: <45D2A835.7020606@m3y3r.de>
Message-ID: <Pine.LNX.4.62.0702140955130.17463@pademelon.sonytel.be>
References: <45D2A835.7020606@m3y3r.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Thomas Meyer wrote:
> with 93bbad8fe13a25dcf7f3bc628a71d1a7642ae61b:
> 
> drivers/video/Kconfig:1604:warning: 'select' used by config symbol 'FB_PS3'
> refer to undefined symbol 'PS3_PS3AV'

It's defined in arch/powerpc/platforms/ps3/Kconfig, which is sourced by
arch/powerpc/Kconfig only.

I don't know what's the best way to shut this up. Anyone with a suggestion?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
