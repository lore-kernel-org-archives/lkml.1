Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbXERTpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbXERTpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbXERTpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:45:33 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:44522 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbXERTpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:45:33 -0400
X-Greylist: delayed 766 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 15:45:32 EDT
Message-ID: <464DFF5F.5010905@tlinx.org>
Date: Fri, 18 May 2007 12:32:47 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: building i386 requires s390: "driver/crypto/Kconfig" sourcing s390
 arch
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems there is an include of s390 based config in file
drivers/crypto/Kconfig: source "arch/s390/crypto/Kconfig"

The line doesn't seem to be need for an i386 build (haven't
tried x86_64 though).

I take it that this was a braino?






