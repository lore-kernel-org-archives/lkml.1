Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYBGQK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYBGQK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYBGQKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:10:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:41634 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754261AbYBGQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:10:12 -0500
Message-ID: <47AB2D97.4060000@ru.mvista.com>
Date: Thu, 07 Feb 2008 19:11:03 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mikael Starvik <starvik@axis.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 3/5] ide: remove ide_setup_ports()
References: <200802020147.29467.bzolnier@gmail.com>
In-Reply-To: <200802020147.29467.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> ide-cris.c:
> * Add cris_setup_ports() helper and use it instead of ide_setup_ports()
>   (fixes random value being set in ->io_ports[IDE_IRQ_OFFSET]).

> buddha.c:
> * Add buddha_setup_ports() helper and use it instead of ide_setup_ports().

> falconide.c:
> * Add falconide_setup_ports() helper and use it instead of ide_setup_ports(),
>   also fix return value of falconide_init() while at it.

> gayle.c:
> * Add gayle_setup_ports() helper and use it instead of ide_setup_ports().

> macide.c:
> * Add macide_setup_ports() helper and use it instead of ide_setup_ports()
>   (fixes incorrect value being set in ->io_ports[IDE_IRQ_OFFSET]).

> q40ide.c:
> * Fix q40_ide_setup_ports() comments.

> ide.c:
> * Remove no longer needed ide_setup_ports().

> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
