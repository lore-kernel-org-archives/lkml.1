Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZCRP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZCRP2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZCRP2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:28:10 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:22808 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZCRP2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=gEITVrh5NiO2S5s/MTae9PTmiyfPxId/+8F0cudbwVgNg9fxl7n95mm6mqvVbjacOP
         FsojthvQc+iSxt6LgXjVq+cxFgVt3/mTeNWu0743w2475pvSfP7rhZCm28AkRBD8Jj56
         +eG+t4cDFcksiCfeShaMu3aBqmufC6QusYS88=
MIME-Version: 1.0
Date: Wed, 18 Mar 2009 10:28:06 -0500
Message-ID: <cfe5f7850903180828k60f844c0l475e328649607e3c@mail.gmail.com>
Subject: MMC: driver fails to recognize insert-remove SD card after data 
	transfer error 84
From: Ishaq Khan <ishaq.groups@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Montavista kernel 2.6.21 on omap2430

I have been trying to fix a problem in the MMC driver on OMAP2430.
After rapid insert and remove SD card operation, I see the following
error message (caused due to data timeout). After this happens the
driver no longer detects insertions/removals..

[ 1013.320000] mmcblk2: error -84 transferring data, sector 7961, nr
8, card status 0x900

followed by bunch of I/O errors

[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7961
[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7962
[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7963
[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7964
[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7965
[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7966
[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7967
[ 1013.330000] end_request: I/O error, dev mmcblk2, sector 7968

I have tried a number of patches that floating around but do no good
to fix this problem. Would appreciate if someone could share their
views regarding this problem.

Thanks

Ishaq
