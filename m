Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998Ab0AFWYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0AFWYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905Ab0AFWYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:24:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64811 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab0AFWYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:24:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=oxkJGnt76GyJdEgd+2u3+VBdGXgXP9CcZCrc0awzIVyF9cATrwb5/wXYcmNmFyPHf7
         uszAtoFEwHoTwlYQ1+p0+Xtnjdv3O2lJM0T7/+2aS7OALAJq6Wf51i0EXwBpiXJwMK69
         kub1mzugVK0fi8TDachIoae8FXmthydnzklCw=
Message-ID: <4B450E63.6090201@gmail.com>
Date: Wed, 06 Jan 2010 23:27:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: add missing parentheses (in comment)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`!' has a higher precedence than `&' so parentheses are required.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/vt6655/iwctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I don't know whether anyone cares because this is in comment

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 108830f..78b4983 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1472,7 +1472,7 @@ if((wrq->flags & IW_ENCODE_DISABLED)==0){
 		if ( index < 4 ) {
 		    pDevice->byKeyIndex = index;
 		}
-		else if(!wrq->flags & IW_ENCODE_MODE) {
+		else if(!(wrq->flags & IW_ENCODE_MODE)) {
 				rc = -EINVAL;
 				return rc;
 	    }
