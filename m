Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYHAGGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYHAGGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 02:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYHAGGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 02:06:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:9680 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYHAGGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 02:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=snBNwHySNhxC018tMqncP1DUdBNdGnLHw2svDV5b1Ds+ZZH+tWI7K6rqg8m+GDti4F
         21Pvmn+hoa/f1zI8qykWDPhapj0G+XyxqHb0qU4juAh9DTaHN08fP4EFxRI1lVtMlOUB
         49vNmB7ulY/70Xz4hk/ZomqvbGysK3Ms5/lkg=
Message-ID: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com>
Date: Fri, 1 Aug 2008 13:06:33 +0700
From: "Yudha Harimantoro T" <yudha.ht@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Error on Make Modules [2.6.27-rc1]
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I make with 2.6.27-rc1 with my oldconfig.

I build the kernel and there's error on modules.
Errors :
-----------------------------------------------------------------------
root@system:/usr/src/linux# make
...................
...................
CC      net/xfrm/xfrm_ipcomp.mod.ko
LD [M] net/xfrm/xfrm_ipcomp.ko
make[1]: Nothing to be done for `__fw_modbuild'.
root@system:/usr/src/linux# make modules
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  Building modules, stage 2.
  MODPOST 545 modules
make[1]: Nothing to be done for `__fw_modbuild'.
root@system:/usr/src/linux#
-----------------------------------------------------------------------

Best regards,
Yudha_HT
