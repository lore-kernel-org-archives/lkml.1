Return-Path: <linux-kernel-owner+w=401wt.eu-S933881AbZIDTTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbZIDTTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933729AbZIDTTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:19:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933686AbZIDTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:19:43 -0400
Date: Fri, 4 Sep 2009 12:19:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "kishore kadiyala" <kishore.kadiyala@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       jarkko.lavinen@nokia.com, madhu.cr@ti.com,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] OMAP4: MMC driver support on OMAP4
Message-Id: <20090904121912.4b4e2b5a.akpm@linux-foundation.org>
In-Reply-To: <34590.192.168.10.89.1251897876.squirrel@dbdmail.itg.ti.com>
References: <34590.192.168.10.89.1251897876.squirrel@dbdmail.itg.ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009 18:54:36 +0530 (IST)
"kishore kadiyala" <kishore.kadiyala@ti.com> wrote:

> This Patch adds basic support for all 5 MMC controllers on OMAP4.
> 
> -Kishore
> 
> Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
> ---
> This patch doesn't include mmc-regulator support
> 
>  arch/arm/mach-omap2/devices.c          |   42 +++++++++++++++++++++++++++++----
>  arch/arm/plat-omap/include/mach/irqs.h |    2 +
>  arch/arm/plat-omap/include/mach/mmc.h  |    9 ++++++-
>  drivers/mmc/host/Kconfig               |    6 ++--
>  drivers/mmc/host/omap_hsmmc.c          |   10 +++++++
>  5 files changed, 60 insertions(+), 9 deletions(-)

This looks like an ARM patch more than an MMC patch.  I grabbed it as
an MMC thing but hopefully someone else will grab it for a more
appropriate tree.

