Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbXEGVOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbXEGVOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXEGVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:14:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbXEGVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:14:41 -0400
Message-ID: <463F9640.4080003@zytor.com>
Date: Mon, 07 May 2007 14:12:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: Long file names in VFAT broken with iocharset=utf8
References: <200705072151.20104.arvidjaar@mail.ru> <60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de> <87fy685w0m.fsf@duaron.myhome.or.jp> <BD281C0E-5278-4944-ABF0-AF692325945C@e18.physik.tu-muenchen.de>
In-Reply-To: <BD281C0E-5278-4944-ABF0-AF692325945C@e18.physik.tu-muenchen.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Kuhn wrote:
>
> No, we don't. At least not when looking at the POSIX spec, which
> explicitly mentions _bytes_ and _not_ unicode characters. So, to be on
> the safe side, FAT filesystems would need to support a NAME_MAX of
> roughly 6*255+3=1533 bytes (not to mention the hassles of forbidden
> sequences, etc.; do we need to count zero-width characters?) and report
> it through pathconf() to userspace, then userspace could do with that
> whatever it liked.
> 
> What happened to: "file names are just sequences of octets, excluding
> '/' and NUL"? Adding unicode parsing to the kernel is completely useless
> _and_ a big trouble maker.
> 

"Filenames are just octets" have never applied to alien filesystems like
VFAT.

	-hpa

