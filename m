Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbZCPOWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbZCPOWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbZCPOW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:22:27 -0400
Received: from h155.mvista.com ([63.81.120.155]:39181 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756145AbZCPOW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:22:26 -0400
Message-ID: <49BE60CD.3030302@ru.mvista.com>
Date: Mon, 16 Mar 2009 17:23:09 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ide: set hwif->expiry prior to calling [__]ide_set_handler()
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <20090209232005.32406.20153.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209232005.32406.20153.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Set hwif->expiry prior to calling [__]ide_set_handler()
>   and drop 'expiry' argument.

> * Set hwif->expiry to NULL in ide_{timer_expiry,intr}()
>   and remove 'hwif->expiry = NULL' assignments.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
