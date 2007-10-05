Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbXJESf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbXJESf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbXJESfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:35:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37470 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbXJESfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:35:10 -0400
Date: Fri, 5 Oct 2007 20:35:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Timur Tabi <timur@freescale.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
In-Reply-To: <4706822D.4070509@freescale.com>
Message-ID: <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
References: <4706822D.4070509@freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 13:27, Timur Tabi wrote:
>
> What's the difference between __LITTLE_ENDIAN and __LITTLE_ENDIAN_BITFIELD? Can
> someone give me an example when __BIG_ENDIAN and __LITTLE_ENDIAN_BITFIELD would
> both be defined simultaneously?

standard x86:
---LSB-- ---2SB-- ---3SB-- ---MSB-- [bytes] LITTLE_ENDIAN
M765432L M765432L M765432L M765432L  [bits] ?_BITFIELD

(Not sure what bitfield type, but I'd guess BIG_ENDIAN_BITFIELD)

standard sparc:
---MSB-- ---3SB-- ---2SB-- ---LSB-- [bytes] BIG_ENDIAN
M765432L M765432L M765432L M765432L  [bits] ?_BITFIELD

(I hope I got these two right)


Theoretical machine with BIG_ENDIAN but LITTLE_ENDIAN_BITFIELD:
---MSB-- ---3SB-- ---2SB-- ---LSB--
L234567M L234567M L234567M L234567M
