Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYKSQQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYKSQQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYKSQQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:16:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:58540 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYKSQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KygVdi+9giSNC2DypnXtUV/1k+I+aGUqT4aoAgCEhGX9rdYV8zmAZgXZJ84t9XdxFf
         FNMm1csbsTtq/RLHQmaRsnaU8GOF+Ki1iSADY85x999Rap5b7mE7dW13WvrcARNT8qa4
         xtvz5COdpQ13AFEdY0Nu11SCmh/CZrUCjyahQ=
Message-ID: <f188924b0811190816g2301b38ap814f64824055cd59@mail.gmail.com>
Date: Wed, 19 Nov 2008 17:16:14 +0100
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Compiler warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I compiled the Linux 2.6.27.6 kernel on Ubuntu 8.10 with gcc (Ubuntu
4.3.2-1ubuntu11) 4.3.2.

The kernel doesn't compile cleanly, the compiler throws warnings.

  CC [M]  drivers/cdrom/cdrom.o
drivers/cdrom/cdrom.c: In function 'cdrom_print_info':
drivers/cdrom/cdrom.c:3273: warning: format not a string literal and
no format arguments

  CC [M]  drivers/char/riscom8.o
drivers/char/riscom8.c: In function 'riscom8_init':
drivers/char/riscom8.c:1598: warning: format not a string literal and
no format arguments
drivers/char/riscom8.c:1608: warning: format not a string literal and
no format arguments

  CC [M]  drivers/char/n_hdlc.o
drivers/char/n_hdlc.c: In function 'n_hdlc_init':
drivers/char/n_hdlc.c:945: warning: format not a string literal and no
format arguments
drivers/char/n_hdlc.c: In function 'n_hdlc_exit':
drivers/char/n_hdlc.c:968: warning: format not a string literal and no
format arguments

  CC [M]  drivers/char/hw_random/intel-rng.o
drivers/char/hw_random/intel-rng.c: In function 'intel_init_hw_struct':
drivers/char/hw_random/intel-rng.c:315: warning: format not a string
literal and no format arguments

  CC [M]  drivers/input/tablet/aiptek.o
drivers/input/tablet/aiptek.c: In function 'show_tabletDiagnosticMessage':
drivers/input/tablet/aiptek.c:1353: warning: format not a string
literal and no format arguments

(I don't know what this means, I am no programmer. I do not subscribe to LKML)
