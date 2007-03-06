Return-Path: <linux-kernel-owner+w=401wt.eu-S965170AbXCFPSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbXCFPSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965174AbXCFPSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:18:37 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:46690 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170AbXCFPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:18:37 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Dirk Schoebel <dirk@liji-und-dirk.de>
Subject: Re: [linux-usb-devel] OOPS with 2.6.20 and 2.6.21-rc2 (mos7720)
Date: Tue, 6 Mar 2007 16:18:26 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <esjg1h$l8d$1@sea.gmane.org> <200703061207.53484.oliver@neukum.org> <esjv78$g3h$1@sea.gmane.org>
In-Reply-To: <esjv78$g3h$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CZY7FYLjRdgV+i8"
Message-Id: <200703061618.26402.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH60/y81w==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CZY7FYLjRdgV+i8
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 6. M=C3=A4rz 2007 15:52 schrieb Dirk Schoebel:

> hmm, applied these patches, still crashes

Please apply the attached debugging patch.

	Regards
		Oliver

--Boundary-00=_CZY7FYLjRdgV+i8
Content-Type: text/x-diff;
  charset="utf-8";
  name="mos.debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mos.debug"

--- a/drivers/usb/serial/mos7720.c	2007-03-06 16:16:16.000000000 +0100
+++ b/drivers/usb/serial/mos7720.c	2007-03-06 16:16:21.000000000 +0100
@@ -334,7 +334,7 @@
 	int port_number;
 	char data;
 	int j;
-
+BUG_ON(port == NULL);
 	serial = port->serial;
 
 	mos7720_port = usb_get_serial_port_data(port);

--Boundary-00=_CZY7FYLjRdgV+i8--
