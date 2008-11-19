Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYKSQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYKSQig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYKSQi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:38:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYKSQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=edtec0Nk0zrNbJBq5UJqCcGjctohBtgbbtffxcnGLUchxl2TvyxRLKTqiTl+ljqeiw
         4hl9/s7hbOoBBxfYjxPCgLKBL0Z5zFktmDWOMrr2D4pML2NMoFVPkn3CHxk1QBpo/Qy7
         rIwwPk090fKThLbMiMJAj50KL6rHbu2rhimaI=
Message-ID: <c23df7cb0811190838x294c8fabs46ddfcaad87ea8e7@mail.gmail.com>
Date: Wed, 19 Nov 2008 14:38:25 -0200
From: "Henrique Almeida" <hdante@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Palm TX MMC driver is not automatically loaded
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When booting the kernel in a Palm TX device, it's not possible to
mount MMC cards because the driver doesn't seem to be automatically
loaded. The card only works after sending an "add" command to the
corresponding "uevent" file in "/sys".

 - Is there a way to configure the kernel to automatically load the
MMC driver, so that the setup is not necessary ? (most drivers load
while linux boots, it's not clear why it's not so with MMC)
 - Are there links/files where I can get more information about uevent and MMC ?

 PS: All the drivers I'm using are built in the kernel, I've disabled
modules support.

 Thanks,

-- 
 Henrique Dante de Almeida
 hdante@gmail.com
