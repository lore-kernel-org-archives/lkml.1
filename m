Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYKVOCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYKVOCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 09:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbYKVOCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 09:02:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:29164 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbYKVOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 09:01:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v/PHLMt02N9wm1kImeyuNxh5qUv0sT80cn0LYbpxXXOKsRtMUnfr4wGT+G1/nCeViL
         dnTNJGal1oNzpKMBosnkhaeEMNKBwhNGvWDetubLYVu8YgiwY5ZUYAIn5yMOAHRWu8WP
         sHKEysGtwAFK7NbSumRXdc6Et3Zgj+P8tgs7k=
Message-ID: <f17812d70811220601p1d7af668mf3265224179753ab@mail.gmail.com>
Date: Sat, 22 Nov 2008 22:01:58 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Cc: spi-devel-general@lists.sourceforge.net, stefan@datenfreihafen.org,
       sameo@openedhand.com, linux-arm-kernel@lists.arm.linux.org.uk,
       "Daniel Ribeiro" <drwyrm@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200811212125.49068.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <20081121160521.016544616@dodger.lab.datenfreihafen.org>
	 <200811212125.49068.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 1:25 PM, David Brownell <david-b@pacbell.net> wrote:
> On Friday 21 November 2008, stefan@datenfreihafen.org wrote:
>> Since the last submission we are also using the spi subsystem and
>> pxa2xx-spi instead of ssp.c directly as before.
>
> I took a quick glance at this and it seemed like it should be
> able to build without depending on PXA ... should certainly
> not include <mach/ssp.h> or <mach/regs-ssp.h>, and it doesn't
> look like it needs PXA-specific stuff like <mach/mfp-pxa27x.h>
> either.
>
> It's also worth removing the reverse dependencies ("select X")
> from Kconfig; they don't work very well for the things which
> those dependencies rely on.
>
> - Dave
>

I'm wondering if it call fall into the regulator framework, along with
a hwmon driver with its attributes being exported by sysfs.
