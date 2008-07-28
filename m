Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYG1AEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYG1AEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYG1AEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:04:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39293
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753196AbYG1AEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:04:15 -0400
Date: Sun, 27 Jul 2008 17:04:15 -0700 (PDT)
Message-Id: <20080727.170415.12257647.davem@davemloft.net>
To: linux-scsi@vger.kernel.org
CC: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Build fallout from scsi merge...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From allmodconfig on sparc64:

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
make[3]: *** Waiting for unfinished jobs....
