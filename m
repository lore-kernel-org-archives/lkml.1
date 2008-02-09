Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYBIRsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYBIRsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYBIRsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:48:05 -0500
Received: from h155.mvista.com ([63.81.120.155]:5231 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbYBIRsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:48:04 -0500
Message-ID: <47ADE788.90504@ru.mvista.com>
Date: Sat, 09 Feb 2008 20:48:56 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: remove ->hold field from ide_hwif_t (take 2)
References: <200802091854.07310.bzolnier@gmail.com>
In-Reply-To: <200802091854.07310.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> ->hold is write-only now, remove it.

> v2:
> * v1 missed bast-ide, palm_bk3710, ide-cs and delkin_cb host drivers.

    And those drivers were reading it, so it wasn't quite write-only. :-)

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
