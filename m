Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYBFSHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYBFSHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYBFSHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:07:22 -0500
Received: from h155.mvista.com ([63.81.120.155]:27094 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230AbYBFSHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:07:21 -0500
Message-ID: <47A9F78D.20904@ru.mvista.com>
Date: Wed, 06 Feb 2008 21:08:13 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ide: remove redundant BUG_ON() from [atapi_]reset_pollfunc()
References: <200802020146.30385.bzolnier@gmail.com>
In-Reply-To: <200802020146.30385.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Same BUG_ON() is present inside ide_set_handler().

    There is no BUG_ON there -- __ide_set_handler() has a check for the same 
condition and a printk(KERN_CRIT)... myabe it should be replaced with BUG_ON()...

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
