Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXGVPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXGVPtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbXGVPqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:46:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:27585 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760657AbXGVPqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=OQBO6QAyRMEN9Hx7kSyDKSAH/8YERril8HCKAtCGcPrVA9+VvgJL3bC1VNOl5KO6cGFx5YKMERzmjrYSSe+HWbDsm3VEfZRX0q6a/uvyJ9QljBfEu6eEzIvyCNl1q403hY3JaBXvzS3qTh1RYt9MM+RETtGmxgwNPLyAch1wK00=
Message-ID: <46A37B5E.9020804@googlemail.com>
Date: Sun, 22 Jul 2007 17:44:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-scsi@vger.kernel.org
Subject: drivers/scsi/ultrastor.c - matching constraint does not allow a register
 , warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this warnings on current git with gcc 4.2.1 :

...

drivers/scsi/ultrastor.c: In function 'find_and_clear_bit_16':
drivers/scsi/ultrastor.c:303: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c: At top level:
drivers/scsi/ultrastor.c:1201: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:1201: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c: In function 'ultrastor_queuecommand':
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:698: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register
drivers/scsi/ultrastor.c:302: warning: matching constraint does not allow a register

...


Regards,

Gabriel C
