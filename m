Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYEDVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYEDVYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYEDVY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:24:29 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:41508 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYEDVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:24:28 -0400
Message-ID: <fa686aa40805041424x26de27a1g16959e7b9c7ddbf2@mail.gmail.com>
Date: Sun, 4 May 2008 15:24:25 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: [PATCH 01/56] microblaze_v2: Kconfig patches
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
X-Google-Sender-Auth: ff98f1d8d1b964b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 5:40 AM,  <monstr@seznam.cz> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
>
>  Signed-off-by: Michal Simek <monstr@monstr.eu>

>  diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
>  new file mode 100644
>  index 0000000..49767d1
>  --- /dev/null
>  +++ b/arch/microblaze/Kconfig
<snip>
>  +config XILINX_UNCACHED_SHADOW
>  +       bool "Are you using uncached shadow for RAM ?"
>  +       depends on MICROBLAZE

Isn't CONFIG_MICROBLAZE a given?


>  diff --git a/arch/microblaze/platform/Kconfig.platform b/arch/microblaze/platform/Kconfig.platform
>  new file mode 100644
>  index 0000000..64cbb80
>  --- /dev/null
>  +++ b/arch/microblaze/platform/Kconfig.platform
<snip>
>  +config HACK
>  +       bool "Increase performance"
>  +       default y

Is this appropriate for mainline?  If so, it should have a better
description.  :-)

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
