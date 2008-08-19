Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYHSTRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYHSTRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYHSTQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:16:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:30498 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYHSTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EazVKxEXwrWv9E8mqXw29Na71iomHGGMFquJ8HFaAr3saYIFHvPCgj2KhZI04/v/HZ
         TNlXOfIjVRjszvhIwalxc6cytVpXp21qB9gznz8eGQFkR6SXdajMyKLVtXe/zX+6Ltxv
         G4mV3nNPwQmf6mWko1W+NbMDrfbkgintzWzFQ=
Message-ID: <ac9c93b10808191216q64c41222n7752c24c089e3303@mail.gmail.com>
Date: Tue, 19 Aug 2008 21:16:56 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: inclusion of <endian.h> in a kernel header? ok or not?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it ok to #include <endian.h> in a kernel header file.
This is done in linux/patchkey.h and linux/soundcard.h but other
places seem to prefer <asm/byteorder.h>

Basically I am looking for a simple way to isolate a piece of endian
specific code (something like #ifdef BIG_ENDIAN ...#endif
