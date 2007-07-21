Return-Path: <linux-kernel-owner+w=401wt.eu-S936578AbXGUJ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936578AbXGUJ4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbXGUJ4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:56:07 -0400
Received: from barikada.upol.cz ([158.194.242.200]:60231 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133AbXGUJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:56:06 -0400
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
In-Reply-To: <469E6335.8010708@zytor.com>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718183359.GK3801@stusta.de> <469E6335.8010708@zytor.com>
Date: Sat, 21 Jul 2007 12:09:40 +0200
Message-Id: <E1ICBu8-0007CU-5M@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Wed, 18 Jul 2007 12:00:05 -0700

>> If this is an issue, then changing i386 back to discarding __exit code 
>> and data at linktime instead of runtime might make a bigger difference.
>
> What would really make a big difference would be to unspool the
> initramfs in such a way that it only requires O(1) instead off O(n)
> extra memory, by freeing memory as it decompresses and decodes the cpio
> ball.

Why it's not done yet, your opinion?

> 	-hpa
____
