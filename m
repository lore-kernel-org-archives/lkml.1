Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbXFRSKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbXFRSKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761790AbXFRSJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:09:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760828AbXFRSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:09:56 -0400
Message-ID: <4676C78D.8040208@zytor.com>
Date: Mon, 18 Jun 2007 10:57:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390 byteorder.h
References: <fa.Xa4Tv0RVV3kUIdHC69Jp/LpQPcg@ifi.uio.no> <fa.D5W5QzyAnzzOD5Ln35+YDQKzWsE@ifi.uio.no> <fa.XhJVn2uLXM0A6yjcYTr2E44DELQ@ifi.uio.no> <fa.tGqwq8EAmSwz5rSn2D2AkvD+yt0@ifi.uio.no> <46769643.7010106@shaw.ca>
In-Reply-To: <46769643.7010106@shaw.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> 
> If we expect userspace apps to include them, then I would vote for no,
> not for anything outside of #ifdef __KERNEL__ in exported headers. Keep
> in mind also that C++ apps may need to include these as well and those
> extensions don't always play well in C++ mode. (Last instance I ran into
> was the ioctl argument checking macros _IOR, _IOW, etc. that create
> non-compiling code if you use them in a C++ program.)
> 

Some of the actual ioctl macros generate silently wrong code if you use
them in a C program.

	-hpa
