Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXIWWwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXIWWwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXIWWwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:52:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:14927 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXIWWwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D/yIXqsROVzDiV1A6QsB5a0PCuTWxkZC6+x0ifNZ8hu7ss4hwVhKNzvhyezmXP9IuCmARTtwoJ15dKTawJB8CO1r5Re8XT4t2bPlffeUENml1hxSPfIoI1RZB3ENF/oQ1LN7K3qQREPiW7vxgvBBEwnoPsNQEGtyPZOAhQ7W+fo=
Message-ID: <95455e980709231552l73bd8c78u46d3a45266749902@mail.gmail.com>
Date: Mon, 24 Sep 2007 08:52:36 +1000
From: hce <webmail.hce@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Ethernet driver on 2.6.22
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am upgrading from kernel 2.6.11 to 2.6.22 on ARM S3C2400A and found
a following issue on 2.6.22.

On 2.6.11, I selected CONFIG_ISA,  CONFIG_NET_PCI and CONFIG_CS89X0 to
build  CS8900A Ethernet driver to kernel, it was running perfect.

But on 2.6.22, I made the same configuration for CS8900A, the cs89x0.o
could not be compiled in to the kernel (or as a module when I tried to
CONFIG_CS89X0=m) unless I commented out depends statement in
drivers/net/Kconfig. I double checked all three are CONFIG_ISA=y,
CONFIG_NET_PCI=y and CONFIG_CS89X0=y. Any explanation please, was I
missing something here?

Thank you.

Regards,

Jim
