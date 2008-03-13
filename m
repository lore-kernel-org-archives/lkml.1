Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYCMSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYCMSXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYCMSXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:23:11 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:44664 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYCMSXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wy5y9cn/IO1aL5wIe03obDPeK/kaZpfm7y3umUNx+gCI61rK6NI2CJZ1ICU8SzNvlq8/IUZUG/gWU2dbXgLJZTU3WlzjszvikOtwt1qwpz1jAtlTOUllo8jUeFc/MV7edB+IDUHfoWj/MMWoWpHVU5yg4sxDV3NOU37klxxopbk=
Message-ID: <9f0508c40803131123j1d4568e3ne72f60e661bff95f@mail.gmail.com>
Date: Thu, 13 Mar 2008 18:23:09 +0000
From: "=?ISO-8859-1?Q?Andr=E9_C=E9sar_de_S=E1?=" <megatronpt@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Need some info/help.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


I saw this in my /var/log/messages


messages:Mar 12 16:57:25 ALC03-SRV10-WEB-BE1 kernel: hda: packet
command error: status=0x51 { DriveReady SeekComplete Error }
messages:Mar 12 16:57:25 ALC03-SRV10-WEB-BE1 kernel: hda: packet
command error: error=0x54


Was able to trace the error back to
/usr/src/linux-2.6.10-2.3.legacy_FC2/include/linux/hdreg.h


The '0x54' line says:
#define SETFEATURES_SET_CACHE   0x54    /* Set Cache segments to SC Reg. Val */


Can somebody give me a brief explanation on what exactly is this problem?
And should I be worried?


Thanks in Advance
-- 
André César de Sá
