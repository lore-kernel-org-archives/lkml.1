Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbZDESE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbZDESE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZDESEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:04:49 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59890 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZDESEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=JvBZ3kx4eH8S4QmBL4HYM44OQoH+7cuaetA9uj/aRt6QDq+nernFjbPoF5NA3haOnt
         nbBrEGxZoml3W41muvBO59uwNnmxCUicIUPgJbimWr/zrTHe0oudSF/lqIB+VKu0x/Cm
         nKvMQ8hEL+aW2T6bMZFkuYywdN248rJl3Cb9U=
MIME-Version: 1.0
Date: Sun, 5 Apr 2009 19:04:45 +0100
X-Google-Sender-Auth: 920bed42abaf8d5a
Message-ID: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com>
Subject: USB disconnect, address 6
From: Jon Grant <jg@jguk.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Would there be a way to propagate the device name back from the scsi
system to the usb so it can name the device which is disconnected in
the output? This saves needing to go hunting to find what the
disconnected device was.

I'll be happy to donate to Linux Foundation if they need some cash to
cover the time to do this.
I'm not on the mailing list, so please include my email address in any replies.

Regards, Jon


Apr  5 18:56:33 data-laptop kernel: [65426.948048] usb 5-1: new high
speed USB device using ehci_hcd and address 6
Apr  5 18:56:33 data-laptop kernel: [65427.132049] usb 5-1:
configuration #1 chosen from 1 choice
Apr  5 18:56:33 data-laptop kernel: [65427.152066] scsi4 : SCSI
emulation for USB Mass Storage devices
Apr  5 18:56:38 data-laptop kernel: [65432.153182] scsi 4:0:0:0:
Direct-Access     Samsung  Mighty Drive     PMAP PQ: 0 ANSI: 0 CCS
Apr  5 18:56:38 data-laptop kernel: [65432.454122] sd 4:0:0:0: [sdc]
2014208 512-byte hardware sectors (1031 MB)
Apr  5 18:56:38 data-laptop kernel: [65432.454867] sd 4:0:0:0: [sdc]
Write Protect is off
Apr  5 18:56:38 data-laptop kernel: [65432.458744] sd 4:0:0:0: [sdc]
2014208 512-byte hardware sectors (1031 MB)
Apr  5 18:56:38 data-laptop kernel: [65432.459866] sd 4:0:0:0: [sdc]
Write Protect is off
Apr  5 18:56:38 data-laptop kernel: [65432.461202]  sdc: sdc1
Apr  5 18:56:38 data-laptop kernel: [65432.462224] sd 4:0:0:0: [sdc]
Attached SCSI removable disk
Apr  5 18:56:38 data-laptop kernel: [65432.462547] sd 4:0:0:0:
Attached scsi generic sg2 type 0
Apr  5 18:56:58 data-laptop kernel: [65451.669308] usb 5-1: USB
disconnect, address 6
