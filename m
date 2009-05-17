Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZEQPWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZEQPWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZEQPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:22:27 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46414 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZEQPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=S4JFsJOJgtLVH/PwhxU3BgWBuARt9DhKGW2kvfrrEj+GcAUQeKaZqfDlxiz+U2wLEv
         ohq1KdDb/qVtqDUIA98x45GXWDmDBhsQgNWOtFqQpImg6tsr5u9FSsY1KJfj3ptWw71J
         vPoP3iv1PL1BubP4YCuxRXVcd+dZwP4JPZyck=
MIME-Version: 1.0
Date: Sun, 17 May 2009 15:22:26 +0000
X-Google-Sender-Auth: 1c8ef74b33074b4a
Message-ID: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com>
Subject: dd if=/dev/random of=data.bin bs=512 count=1
From: Jon Grant <jg@jguk.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Issuing this command, I expected to get a file 4096 bytes in size.
Could someone let me know if I have missed something..? Or is there a
problem with using /dev/random this way?

if I have a count=10 it hangs forever (several hours).

Changing to use /dev/urandom and it generates the file ok.

Please include my email address in replies,  as I'm not a member of this list.

Best regards, Jon

$ dd if=/dev/random of=data.bin bs=512 count=1
0+1 records in
0+1 records out
8 bytes (8 B) copied, 4.47366 s, 0.0 kB/s

$ dd --version
dd (coreutils) 6.10

$ uname -a
Linux ubuntu 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC
2009 i686 GNU/Linux
