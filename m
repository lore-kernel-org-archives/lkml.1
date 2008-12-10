Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYLJSpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYLJSpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYLJSpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:45:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56113 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYLJSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:45:21 -0500
Message-ID: <49400E0F.5030906@vlnb.net>
Date: Wed, 10 Dec 2008 21:44:31 +0300
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
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH][RFC 10/23]: SCST user space backend handler
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/FM+G8kJjx+7zkxiS3LCJWk/8l6mXnoo5Ol2o
 Bhrq3V3XA53FivD8qrOnFpn7+mH2cogbA3FMy0fDPn6LIHIJT/
 ncS3xXEzDNhAIKlX7OLYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains user space backend dev handler. It allows to 
implement in the user space virtual SCSI devices in the SCST 
environment. See description of its interface here: 
http://scst.sourceforge.net/scst_user_spec.txt

An example of an application that uses this interface is fileio_tgt. You 
can download this software from 
https://sourceforge.net/project/showfiles.php?group_id=110471&package_id=283232. 
This application is a full feature virtual disk emulator similar to 
scst_vdisk backend dev handler.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/dev_handlers/scst_user.c | 3059 ++++++++++++++++++++++++++++++++++
  include/scst/scst_user.h              |  266 ++
  2 files changed, 3325 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_user.diff



