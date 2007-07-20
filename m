Return-Path: <linux-kernel-owner+w=401wt.eu-S935301AbXGTQy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301AbXGTQy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939860AbXGTQtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:49:05 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55510 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932980AbXGTQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:49:00 -0400
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-mips@linux-mips.org
In-Reply-To: <20070720164324.097994947@mail.of.borg>
References: <20070720164043.523003359@mail.of.borg>
	 <20070720164324.097994947@mail.of.borg>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:48:57 -0500
Message-Id: <1184950138.3455.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 18:40 +0200, Geert Uytterhoeven wrote:
> plain text document attachment (m68k-wd33c93-needs-asm-irq.diff)
> wd33c93 SCSI needs <asm/irq.h> on m68k
> 
> drivers/scsi/wd33c93.c: In function 'wd33c93_host_reset':
> drivers/scsi/wd33c93.c:1582: error: implicit declaration of function 'disable_irq'
> drivers/scsi/wd33c93.c:1603: error: implicit declaration of function 'enable_irq'
> 
> The driver still compiles on MIPS (CONFIG_SGIWD93_SCSI=y)

That's fixed here, isn't it:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=078dda95c521b1c78d1b5da69ac90d581abc9951

(sorry about the lack of descriptive subject line)

James


