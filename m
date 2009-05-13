Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZEMNYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZEMNYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZEMNXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:23:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:8908 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZEMNXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cwnv7VLHe6xm1va2e7o3HX5c8GSAIFiOwnDSBKvvf5Ao0dw+08Wl025F1dTjmv5QuJ
         YmJcq5YRZHZw89lWJCpnn11Qtkef+EnXZow76qja6f33yGlcM/u8wK3Dge4y3msufOpz
         iCAj0Nt5NzvuLmNIbJiwmYFDFLO/q84XzJa4Q=
Date: Wed, 13 May 2009 17:23:42 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: data.c should include delay.h
Message-ID: <20090513132342.GA16280@orion>
References: <1242219648-16165-1-git-send-email-a.beregalov@gmail.com> <1242219648-16165-2-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242219648-16165-2-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
.../data.c:86: error: implicit declaration of function 'udelay'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

This one is better.

 drivers/staging/comedi/kcomedilib/data.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/kcomedilib/data.c b/drivers/staging/comedi/kcomedilib/data.c
index 3e5fe2c..d808556 100644
--- a/drivers/staging/comedi/kcomedilib/data.c
+++ b/drivers/staging/comedi/kcomedilib/data.c
@@ -26,6 +26,7 @@
 #include "../comedidev.h"
 
 #include <linux/string.h>
+#include <linux/delay.h>
 
 int comedi_data_write(void *dev, unsigned int subdev, unsigned int chan,
 	unsigned int range, unsigned int aref, unsigned int data)
