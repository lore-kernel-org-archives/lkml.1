Return-Path: <linux-kernel-owner+w=401wt.eu-S1763708AbXFFLtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708AbXFFLtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXFFLtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:49:06 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:39237 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbXFFLtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:49:05 -0400
X-Greylist: delayed 1187 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 07:49:05 EDT
Message-ID: <46669A89.3010500@grupopie.com>
Date: Wed, 06 Jun 2007 12:29:13 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 05/18] fs/logfs/logfs.h
References: <20070603183845.GA8952@lazybastard.org> <20070603184303.GF8952@lazybastard.org>
In-Reply-To: <20070603184303.GF8952@lazybastard.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> --- /dev/null	2007-03-13 19:15:28.862769062 +0100
> +++ linux-2.6.21logfs/fs/logfs/logfs.h	2007-06-03 19:34:07.000000000 +0200
> @@ -0,0 +1,398 @@
> +/*
> + * fs/logfs/logfs.h
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2005-2007 Joern Engel
> + *
> + * Private header for logfs.
> + */
> +#ifndef fs_logfs_logfs_h
> +#define fs_logfs_logfs_h
> +
> +#define __CHECK_ENDIAN__
> +
> +
> +#include <linux/crc32.h>
> +#include <linux/fs.h>
> +#include <linux/kallsyms.h>

Including kallsyms.h is not really needed in this header file, is it?

I don't have time / knowledge to review the rest of the code, but I 
always keep an eye out for kallsyms usage...

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
