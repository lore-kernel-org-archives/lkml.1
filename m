Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbXHCJ7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbXHCJ7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 05:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbXHCJ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 05:59:39 -0400
Received: from web26910.mail.ukl.yahoo.com ([217.146.176.99]:31343 "HELO
	web26910.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758238AbXHCJ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 05:59:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=lz+dI3lXLJRxJfXUfyXOo8UwA+zBf6xXmPdpk57rjveh2bW++AQWsI0SE7ykFnbcMXyicRTQPs5KhQSHiZAgDBMMdJeFdd6lwge8f2ePeQ3OWd5qJIOmMfU4MDwf8EPkW2FQ7ztqIs790qoy5qoEeJlITL7BBIhYNlKJRMiQ/C0=;
X-YMail-OSG: YiG_.NoVM1nxa3yCwykpQs.gKHgJc7e8UI6uwRvfkL6f1KiX5xn1pOG01xl9RFVL.7n5RrG.MQ--
Date: Fri, 3 Aug 2007 11:59:37 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: [ANNOUNCE] Gujin PC graphic bootloader version 2.1
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <466131.83757.qm@web26910.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

 A new version of the Gujin bootloader has been released, with those improvements:

- Uses now by default the 16 bits entry point of bzImage Linux files (zImage not
 supported) and do not uncompress the initrd, under the control of the "force
 bzImage protocol" of the graphic menu, or the "/p" parameter of tiny.exe.

- Able to load (gzip'ed) 64 bits ELF files with the ".kgz" extension (like 32 bits
 ELF - with possible section at ELF address 0 for the real-mode part) as long as
 the entry point is a 32 bits entry point (i.e. use runadr=0x200000 parameter
 inside the comment field of the GZIP'ed ELF64 file).

- Uses if possible/autodetected the name of the filesystem in "root=LABEL="
 Linux parameter, instead of the autodetected "root=/dev/hd[a-z][0-9]".

- Important fixes in the demo cleandisk.kgz standalone application (linker file
 cleandisk.ld change) directly runable from Gujin, with full disk, graphic and
 mouse support.

- Longer timeout (change from 4 to 8 seconds) to read a CDROM sector, so that new
 ultra speed DVD-RAM drives can be booted...

- More bugfixes, like when chain-loading floppy images from CDROMs or USD drives,
 loading the last uncomplete block of the initrd...

 Have fun,
 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
