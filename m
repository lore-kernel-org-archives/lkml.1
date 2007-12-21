Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbXLUMDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbXLUMDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXLUMDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:03:17 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:30246 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbXLUMDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:03:16 -0500
Message-ID: <476BAB99.1030606@ru.mvista.com>
Date: Fri, 21 Dec 2007 15:03:37 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/63] ide-cd: fix DMA error handling in cdrom_newpc_intr()
References: <200712200202.06988.bzolnier@gmail.com>
In-Reply-To: <200712200202.06988.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Make cdrom_newpc_intr() match cdrom_{read,write}_intr() w.r.t.
> handling DMA errors:

> * disable DMA before cdrom_decode_status() call

> * log the device name and the type of the request (read/write)

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

