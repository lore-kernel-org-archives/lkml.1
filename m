Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXAWJNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXAWJNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbXAWJNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:13:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:59131 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbXAWJNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:13:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tw98osV4uHnc1tOVDRuR/dqc6nNmF9NKyqx08/nmY2/beKK5eL7+Vt0GmoOngACV9xgV3tppDwQLNliJRvzU+DLk0SBYUQYSyb1SdKZCcrrxAImpDeZbmowjZ14uXRWdz4Nm+te5vBI4GYyadsQm9j4wMmxm7jswSjiESXQl5pY=
Message-ID: <f36b08ee0701230113m2f244a4et5cf866cf1b38f4d4@mail.gmail.com>
Date: Tue, 23 Jan 2007 11:13:03 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: usb2 external disk not recognized if connected during boot, but recognized if not connected during boot
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a small Celeron-based appliance, Usb2 disk is not recognized *if*
it is connected during kernel boot.
But if not connected during boot, and I connect it later, it is
recognized and works ok.
I tried various 2.6.16, 17 and 18 kernels, both modular, and
all-static, with the same result.
What can this be.
This is ehci controller. Can it be problematic Irq assignments on the
motherboard ?
Btw, during boot, access lights go on forever on the Usb drive. Couple
of kernels are stuck
at this point. Most kernels go through, but disk is still not
recognized. If I disconnect and re-connect usb drive later, then it is
never recognized (if it was connected earlier during boot). Again, if
the disk was not connected during boot, all kernels recognize it and
work with it.

Thank
Yakov
