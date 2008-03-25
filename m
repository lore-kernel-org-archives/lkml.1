Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbYCYQsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbYCYQsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbYCYQrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:47:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:46210 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbYCYQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:47:54 -0400
Message-ID: <47E92D0E.6040901@ru.mvista.com>
Date: Tue, 25 Mar 2008 19:49:18 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] ide: remove IDE_HFLAG_NO_AUTOTUNE host flag
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain> <20080322220639.17636.80893.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220639.17636.80893.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Don't set IDE_HFLAG_NO_AUTOTUNE host flag in sgiioc4 and icside
>   host drivers - there is no need for it as they don't implement
>   ->set_pio_mode method.

> * Remove no longer needed IDE_HFLAG_NO_AUTOTUNE host flag.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
