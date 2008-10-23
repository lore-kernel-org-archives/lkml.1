Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYJWV6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYJWV6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJWV6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:58:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:35243 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYJWV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FMp3b8g2sKrpJgaEls9vMa/EFMLqfhfKqy5NNIJMNSSTZ89hcQ0R89NlCqfZHLbakO
         NRBSCLl6pFpJXFVqk3XAUQgMApZ8jreI+c27QE7M6QsIX14Y6AFFyBRg8Y6T8XP/as1K
         T2Ed0b4wEKvHgbMo0WtjGEyo1WqKuJAfPidqc=
Message-ID: <f7848160810231458tea58cf7x362ad03743b564ed@mail.gmail.com>
Date: Thu, 23 Oct 2008 17:58:34 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Stale NFS File Handle but !NFS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone got an idea why I am getting the below error with today's git
while compiling the kernel?

  LD      arch/x86/vdso/built-in.o
scripts/Makefile.build:373: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
make[2]: stat: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
make[2]: *** No rule to make target `net/netfilter/.xt_mac.o.cmd'.  Stop.
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2
parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ rm net/netfilter/.xt_mac.o.cmd
rm: cannot remove `net/netfilter/.xt_mac.o.cmd': Stale NFS file handle
parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ sudo rm
net/netfilter/.xt_mac.o.cmd

Even trying 'sudo rm -f' on that file gives the same error.

I am not using NFS at all which makes this one sound weird!

Thanks
Parag
