Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZL3XAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZL3XAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZL3W76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:59:58 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39295 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZL3W74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TM1rG8dLOcwE6z07WV/jicBfbXIE6/a7AZuesS4ndnYKSQ+4gRlNDiFnrO+wbJAWv5
         cu4oN2admmrK9icjOwdq4wOGs7bFZBkb/XnbATX/rm/FTGypIe1kZpyFmm08N0RWKrPM
         KWmD5EVky0JPlXANmLdvBh4Hcj6iBI4HrtHX0=
Message-ID: <4B3BDB66.6000008@googlemail.com>
Date: Wed, 30 Dec 2009 23:59:50 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need this ;-).

Best regards René Bolldorf & a happy new year in advance.

--- ./drivers/ata/libata-eh.c  2009-12-30 23:44:05.578988545 +0100
+++ ./drivers/ata/libata-eh.c  2009-12-30 23:45:06.991987607 +0100
@@ -1505,9 +1505,6 @@ static unsigned int atapi_eh_request_sen

  	DPRINTK("ATAPI request sense\n");

-	/* FIXME: is this needed? */
-	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
-
  	/* initialize sense_buf with the error register,
  	 * for the case where they are -not- overwritten
  	 */
