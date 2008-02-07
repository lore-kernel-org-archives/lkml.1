Return-Path: <linux-kernel-owner+w=401wt.eu-S1760487AbYBGMz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbYBGMz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYBGMzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:55:09 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:38750 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753142AbYBGMzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:55:07 -0500
Message-ID: <47AAFFDF.7010809@ru.mvista.com>
Date: Thu, 07 Feb 2008 15:55:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ide: remove redundant BUG_ON() from [atapi_]reset_pollfunc()
References: <200802020146.30385.bzolnier@gmail.com> <47A9F78D.20904@ru.mvista.com> <200802062143.19121.bzolnier@gmail.com>
In-Reply-To: <200802062143.19121.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>>Same BUG_ON() is present inside ide_set_handler().

>>    There is no BUG_ON there -- __ide_set_handler() has a check for the same 
>>condition and a printk(KERN_CRIT)... myabe it should be replaced with BUG_ON()...

> Yeah, you're right - care to make a patch?

    Replacing printk() with BUG_ON() and also removing BUG_ON() from 
ide_execute_command()? OK, will do...

>>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

>>Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
