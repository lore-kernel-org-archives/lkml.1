Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZAFK0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZAFK0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZAFK0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:26:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38066 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZAFK0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:26:30 -0500
Message-ID: <4963311B.6020502@redhat.com>
Date: Tue, 06 Jan 2009 11:23:23 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, bluebird@gentoo.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
References: <4943DAD6.7070402@gentoo.org>	 <20081216.011334.124918024.davem@davemloft.net> <1229564779.6481.26.camel@brick>
In-Reply-To: <1229564779.6481.26.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> glibc headers define both __LITTLE_ENDIAN and __BIG_ENDIAN
> which was tripping the check in linux/byteorder.h.  Let's
> just stay out of userspace's way and use __KERN_{endian}

Ping.  What is the status of this?

> Converted the arches in mainline that have already moved to the
> new header, as the other arches merge the will need simlar
> fixups.

In latest git powerpc, s390 and x86 are merged and need this fix too.

cheers,
  Gerd
