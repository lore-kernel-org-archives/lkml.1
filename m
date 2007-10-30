Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbXJ3DxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbXJ3DxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXJ3Dw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:52:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:14943 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbXJ3Dwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=TWyzHtyuL5qINQ7wh2AeE6t3NII1uE+0/A50FqydVdUg5bw0fueH+14UHZu+EenAy7xO/iOplSDOl/2KsyX1R/KBOYG08Yj3ifh3fzij9SPGZekuIs5VCtxHiuAY7sOCIUmcB74pylAvdNP/MDKyY7/prdoAMwqxp1FDSYclcvs=
Message-ID: <4726AA6B.7090706@googlemail.com>
Date: Tue, 30 Oct 2007 04:52:11 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Domen Puncer <domen.puncer@telargo.com>,
       Dale Farnsworth <dale@farnsworth.org>, Jeff Garzik <jeff@garzik.org>
Subject: Kconfig warnings from FEC_MPC52xx
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see these warning on my x86_32 box :

..

drivers/net/Kconfig:1887:warning: 'select' used by config symbol 'FEC_MPC52xx' refers to undefined symbol 'PPC_BESTCOMM'
drivers/net/Kconfig:1888:warning: 'select' used by config symbol 'FEC_MPC52xx' refers to undefined symbol 'PPC_BESTCOMM_FEC'

..

introduced by :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5d031e9e7e9ad5aa6516646f955c6262478e1acd

Regards,

Gabriel C
