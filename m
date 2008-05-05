Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYEEEVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYEEEVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYEEEVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:21:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:6067 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYEEEVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ecvM6IzEaBVuyjFO4LZztAQZkjB2yYwpPE49DMDeuPlE9L3uiW4X5SdkYAdgAchJ5YiLo/hs8QBisKxWnaAt2TjZZgOx+5rzhQxOFu7In+0yFhYuqwjKUhwf0TUajYvSmyO4lo80rlxd57sPrAR9CF7cI3bmv+FHcqO/4J8t3Fs=
Message-ID: <aa79d98a0805042121s1113e308obfd631581e826e0b@mail.gmail.com>
Date: Mon, 5 May 2008 08:21:15 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] x86: x86-64defconfig remake
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080504181359.a39d766b.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504155719.GA6842@cvg> <20080504181359.a39d766b.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 3:13 AM, Paul Jackson <pj@sgi.com> wrote:
> Cyrill wrote:
>  > The current x86_64_defconfig contains a number of nonexistent
>  > symbols.
>
>  These symbols don't exist in what context?
>
>  The one I notice:
>
>
>  -# CONFIG_CPUSETS is not set
>
>  certainly exists, in init/Kconfig:
>
>     config CPUSETS
>         bool "Cpuset support"
>         depends on SMP && CGROUPS
>
>  and is enabled by default in some configs:
>
>     arch/ia64/configs/sn2_defconfig
>     arch/mips/configs/ip27_defconfig
>     arch/mips/configs/sb1250-swarm_defconfig
>     arch/powerpc/configs/cell_defconfig
>     arch/powerpc/configs/ppc64_defconfig
>     arch/powerpc/configspseries_defconfig
>
>  I could be tempted to enable cpusets by default in x86_64
>  as well, however I don't understand the tradeoffs of such
>  a change well enough to know if I should propose that.
>
>  --
>                   I won't rest till it's the best ...
>                   Programmer, Linux Scalability
>                   Paul Jackson <pj@sgi.com> 1.940.382.4214
>

Thanks Paul for feedback, will take a look today evening.
