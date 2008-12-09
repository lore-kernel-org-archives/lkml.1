Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYLIVNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYLIVNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYLIVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:12:52 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:57064 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYLIVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:12:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=SKKHC6FyUqukZTv3T09//nbrJd32cHt/Go33ddptVLUwJyzdQC/wrdIDrk+667c3oz
         Hy19Md3+7XtB3UtRZWdSkARIkUe2GlJxzkfbb0GuiUgpAZ9NfzYi7WxM4dtyA6bflnAf
         FpUQuElY7ao2osuEUMEsWmyH37YUrJBbe7Vig=
Message-ID: <493EDF52.1000506@gmail.com>
Date: Tue, 09 Dec 2008 22:12:50 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/31] drivers/pcmcia: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/pcmcia/pcmcia_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_ioctl.c b/drivers/pcmcia/pcmcia_ioctl.c
index 1703b20..8b8ac7c 100644
--- a/drivers/pcmcia/pcmcia_ioctl.c
+++ b/drivers/pcmcia/pcmcia_ioctl.c
@@ -286,7 +286,7 @@ static int pccard_get_status(struct pcmcia_socket *s,
 	return 0;
 } /* pccard_get_status */
 
-int pccard_get_configuration_info(struct pcmcia_socket *s,
+static int pccard_get_configuration_info(struct pcmcia_socket *s,
 				  struct pcmcia_device *p_dev,
 				  config_info_t *config)
 {

