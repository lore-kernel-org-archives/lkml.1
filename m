Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbZADX6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbZADX6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZADX6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:58:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZADX6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:58:32 -0500
Message-ID: <49614D1F.8020900@zytor.com>
Date: Sun, 04 Jan 2009 15:58:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu>
In-Reply-To: <49614491.7020903@knaff.lu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have pulled the x86 parts of the bzip2/lzma patchset into
tip:x86/setup-lzma.  I would appreciate it if you could look at it and
make sure it looks sane.  I have not added the ARM portions (patch 4),
since those should go via the ARM tree, nor the capstone patch 5, which
can only be added after the old code is removed from *all* remaining
architectures.

Ingo: this *will* break your randconfig testing if you have machines
where the lzma(1) utility isn't installed!

The shortlog looks like:

Alain Knaff (3):
      bzip2/lzma: library support for gzip, bzip2 and lzma decompression
      bzip2/lzma: config and initramfs support for bzip2/lzma 	decompression
      bzip2/lzma: x86 kernel compression support

H. Peter Anvin (3):
      bzip2/lzma: use a table to search for initramfs compression formats
      bzip2/lzma: handle failures from bzip2 and lzma correctly
      bzip2/lzma: make config machinery an arch configurable

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

