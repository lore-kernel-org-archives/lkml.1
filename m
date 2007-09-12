Return-Path: <linux-kernel-owner+w=401wt.eu-S1762382AbXIMJYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbXIMJYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbXIMJYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:24:05 -0400
Received: from mail.suse.de ([195.135.220.2]:48328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbXIMJYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:24:03 -0400
From: Andi Kleen <ak@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [2.6.23-rc6] i386 build breakage on current git
Date: Wed, 12 Sep 2007 18:31:03 +0200
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, maxk@qualcomm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <46E81433.5070702@garzik.org>
In-Reply-To: <46E81433.5070702@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709121831.04252.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 18:30, Jeff Garzik wrote:
> Platform i386 seems to be missing struct compat_timeval, which causes
> the i386 allmodconfig build to break in current -git:
>
> net/bluetooth/hci_sock.c: In function ‘hci_sock_cmsg’:
> net/bluetooth/hci_sock.c:352: error: storage size of ‘ctv’ isn’t known
> net/bluetooth/hci_sock.c:352: warning: unused variable ‘ctv’
> make[2]: *** [net/bluetooth/hci_sock.o] Error 1

All compat_* types should be only used inside #ifdef CONFIG_COMPAT
which i386 never sets. Bluetooth is broken

-Andi
