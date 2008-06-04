Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYFDJle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYFDJle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYFDJlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:41:24 -0400
Received: from h155.mvista.com ([63.81.120.155]:12027 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752008AbYFDJlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:41:23 -0400
Message-ID: <4846633D.9020103@ru.mvista.com>
Date: Wed, 04 Jun 2008 13:41:17 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] delkin_cb: set proper hwif->gendev.parent value
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain> <20080602202309.7265.47071.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202309.7265.47071.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> hwif->dev was set too late (after ide_device_add() call)
> so hwif->gendev.parent was not initialized properly.
>
> Fix it by setting hw.dev and letting ide_init_port_hw()
> do the rest.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


