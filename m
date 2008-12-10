Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbYLJSv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbYLJSv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYLJSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:51:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYLJSvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:51:14 -0500
Message-ID: <49400F82.1040603@vlnb.net>
Date: Wed, 10 Dec 2008 21:50:42 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>, linux-driver@qlogic.com,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH][RFC 14/23]: Necessary functionality in qla2xxx driver to
 support target mode
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX187OcDNS5cZhBfAqUne6eeFe7vzWRJPBhpmRPN
 7UUFKJ5Yr8ZQR+2tfdUkW7IRjld50RWhVBx9W4jdZhylqSw/o6
 VcEMmFIczWbPHFj3W8fdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds necessary functionality in qla2xxx driver to support 
SCST target mode add-on. Basically, it only adds the necessary for the 
target mode add-on constants, hooks, sysfs entries and initialization 
actions. It doesn't touch any core functionality of qla2xxx driver.

This patch needs patches http://article.gmane.org/gmane.linux.scsi/43495 
and http://article.gmane.org/gmane.linux.scsi/43475, but doesn't require 
them.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scsi/qla2xxx/Kconfig         |   10 +
  drivers/scsi/qla2xxx/qla2x_tgt.h     |  120 ++++++++++++++++++
  drivers/scsi/qla2xxx/qla2x_tgt_def.h |  362 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scsi/qla2xxx/qla_attr.c      |  324 ++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scsi/qla2xxx/qla_def.h       |   11 +
  drivers/scsi/qla2xxx/qla_gbl.h       |    9 +
  drivers/scsi/qla2xxx/qla_gs.c        |   11 +
  drivers/scsi/qla2xxx/qla_init.c      |  235 ++++++++++++++++++++++++++++++++----
  drivers/scsi/qla2xxx/qla_iocb.c      |    7 -
  drivers/scsi/qla2xxx/qla_isr.c       |  123 +++++++++++++++++++
  drivers/scsi/qla2xxx/qla_mbx.c       |   14 +-
  drivers/scsi/qla2xxx/qla_os.c        |   14 ++
  12 files changed, 1201 insertions(+), 39 deletions(-)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/qla_tgt.diff


