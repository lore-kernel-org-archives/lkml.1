Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZG0Qre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZG0Qre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZG0Qre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:47:34 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:53461 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZG0Qrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ufFSzOwAKJlUyP9sspUCeBaLXXZLp/SY7uk9VzbhkAbmyVbAAaufQmI9PpVWfJDuX7
         bx2lvLHz5KC95z4/VuM7+g9MdlZG5T15uHx2QUHNcgFikndwZLwYXXqEOKAkQVgUZIJS
         Z0t2iOJursdM03X8FTxDNl7qYmgPTxK+bpCbs=
MIME-Version: 1.0
Date: Tue, 28 Jul 2009 00:47:33 +0800
Message-ID: <86bb1aef0907270947o6219f950xf13a077b30486d41@mail.gmail.com>
Subject: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
From: wan wei <onewayforever@gmail.com>
To: dougthompson@xmission.com, borislav.petkov@amd.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 858fe60..95b1096 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2979,6 +2979,7 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)

                /* CLEAR the override, since BIOS controlled it */
                ecc_enable_override = 0;
+               ret = 0;
        }

        return ret;
