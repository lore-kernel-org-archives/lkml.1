Return-Path: <linux-kernel-owner+w=401wt.eu-S1161054AbXBRCEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161054AbXBRCEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161048AbXBRCEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:04:48 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:57660 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161054AbXBRCEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:04:47 -0500
Date: Sun, 18 Feb 2007 03:04:42 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Olaf Hering <olaf@aepfle.de>
cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] override build timestamp
In-Reply-To: <20070216215213.GA10732@aepfle.de>
Message-ID: <Pine.LNX.4.64.0702180259210.14458@scrub.home>
References: <20070216215213.GA10732@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 16 Feb 2007, Olaf Hering wrote:

> Pass a timestamp to kbuild via an enviroment variable.
> 
>     TZ=UTC BUILD_TIMESTAMP=2007-01-01 make -kj O=../O vmlinux
> 
> This can be used when the kernel source is in a SCM and uname -v
> is supposed to give the commit date and not the package build time.

Is this really necessary? I don't really see the point of this.

bye, Roman
