Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbYAGDRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbYAGDRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYAGDRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:17:43 -0500
Received: from comsmtp2.singnet.com.sg ([165.21.101.75]:39676 "EHLO
	comsmtp2.singnet.com.sg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYAGDRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:17:43 -0500
To: linux-kernel@vger.kernel.org
Subject: Odd behaviour observed on fb0 (TFT LCD screen 800x480)
Message-ID: <1199675857.478199d155026@discus.singnet.com.sg>
Date: Mon, 07 Jan 2008 11:17:37 +0800 (SGT)
From: cksim <cksim@singnet.com.sg>
Reply-To: cksim@singnet.com.sg
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: SingNet WebMail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lately, I have observed an odd behviour in kernel 2.6.23.1 on a 800x480 TFT LCD unit.

The odd behviour as follows:
1) I am using Atmel AT91SAM9261 part. Circuit similar to that of AT91SAM9261EK evaluation board.

2) I am booting the kernel and mounting root filesystem through NFS. Bootloader used is UBoot 1.1.5.

3) During kernel startup, the LCD screen shows the "Penguin" logo with the other console output messages.

4) Everything looks fine up to this point. For example, the 0,0 position of image on LCD is proper and correct.

5) The root filesystem is then mounted through NFS and followed by a message "Freeing init memory: 106K". All this are fine.

6) During the execution of init scripts and the login prompt, the image on the screen starts shifting (either left, right, up or down). For example, the 0,0 position of the LCD image is shifted. However, the image content is still correct.

7) After login, this image shift behaviour still exists during normal usage.

In contrast, when using kernel 2.6.21, the image shift behaviour was not observed before the login prompt. Image shift after the login does happen occasionally but not as frequent as that seen in 2.6.23.1.

Has anyone encountered a similar image shift issue ?

Is this issue related to kernel ? It appears to me that some timing causes the image shifting.

Appreciate any help and advises.

Thanks in advance.

Sim CK

