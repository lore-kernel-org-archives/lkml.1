Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbXLULxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbXLULxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbXLULxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:53:01 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:30178 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbXLULxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:53:00 -0500
Message-ID: <476BA931.90703@ru.mvista.com>
Date: Fri, 21 Dec 2007 14:53:21 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/63] ide-cd: fix SAMSUNG CD-ROM SCR-3231 quirk
References: <200712200150.29036.bzolnier@gmail.com>
In-Reply-To: <200712200150.29036.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> cdi->mask is cleared by ide_cdrom_register() which is called after the quirk.

> Fix it by adding new ->no_speed_select flag to struct ide_cd_config_flags
> and using it in ide_cdrom_register() to set CDC_SELECT_SPEED flag.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
