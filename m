Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYDPSNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYDPSNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYDPSNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:13:30 -0400
Received: from h155.mvista.com ([63.81.120.155]:34574 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750823AbYDPSN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:13:29 -0400
Message-ID: <480641A2.1080004@ru.mvista.com>
Date: Wed, 16 Apr 2008 22:12:50 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] ide: add ->tf_load and ->tf_read methods
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain> <20080412123415.18751.51136.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123415.18751.51136.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add ->tf_load and ->tf_read methods to ide_hwif_t and set the default
>   methods in default_hwif_transport().

    It's not clear to me what do we gain with addign such methods...

> * Use ->tf_{load,read} instead o calling ide_tf_{load,read}() directly.

> * Make ide_tf_{load,read}() static.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
