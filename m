Return-Path: <linux-kernel-owner+w=401wt.eu-S934509AbXFFNtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934509AbXFFNtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763942AbXFFNtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:49:10 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3005 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763680AbXFFNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:49:08 -0400
Message-ID: <4666BB65.8050800@shadowen.org>
Date: Wed, 06 Jun 2007 14:49:25 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1 -- ia64 build failure
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing this on an ia64:

drivers/built-in.o: In function `efi_setup_pcdp_console':
(.init.text+0x13be2): undefined reference to `early_serial_console_init'
drivers/built-in.o: In function `efi_setup_pcdp_console':
(.init.text+0x13de2): undefined reference to `early_serial_console_init'
make: *** [.tmp_vmlinux1] Error 1
