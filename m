Return-Path: <linux-kernel-owner+w=401wt.eu-S1760489AbYB0VIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489AbYB0VIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758431AbYB0VH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:07:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:35907 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbYB0VHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=lpVX+5aT/sY8KBGsRpZ259fI5t6l5Vbh7EKOZoi19h1gK51G2qCtv9UjR8/AihR9S6pB87nTB77SRrvfHAkxNpv8jSaDyvmW4exwtcH4CeIpM+zWn7pPVwGIRmAJLg522SJ83xRDAZXA3TR5khrOF3Y+7zVp+/VDIX5o9iOFaac=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 5/5] ide-cd: fix remaining checkpatch.pl issues
Date: Wed, 27 Feb 2008 22:18:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <1204136449-9490-6-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204136449-9490-6-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802272218.53175.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008, Borislav Petkov wrote:
> Some of them are:
> WARNING: braces {} are not necessary for single statement blocks
> CHECK: multiple assignments should be avoided
> WARNING: printk() should include KERN_ facility level
> WARNING: no space between function name and open parenthesis '('
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

interdiff for the merged version

diff -u b/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
--- b/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -185,8 +185,7 @@
 			if (valid < 0)
 				valid = 0;
 			if (sector < get_capacity(info->disk) &&
-				drive->probed_capacity - sector < 4 * 75)
-
+			    drive->probed_capacity - sector < 4 * 75)
 				set_capacity(info->disk, sector);
 		}
 	}
@@ -218,7 +217,7 @@
 
 	rq->data = sense;
 	rq->cmd[0] = GPCMD_REQUEST_SENSE;
-	rq->cmd[4]   = 18;
+	rq->cmd[4] = 18;
 	rq->data_len = 18;
 
 	rq->cmd_type = REQ_TYPE_SENSE;
@@ -310,8 +309,8 @@
 	sense_key = err >> 4;
 
 	if (rq == NULL) {
-		printk(KERN_ERR "%s: missing rq in cdrom_decode_status\n",
-			drive->name);
+		printk(KERN_ERR "%s: missing rq in %s\n",
+				drive->name, __func__);
 		return 1;
 	}
 
