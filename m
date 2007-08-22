Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXHVC6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXHVC6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXHVC6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:58:35 -0400
Received: from main.gmane.org ([80.91.229.2]:46220 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbXHVC6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:58:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: What must I do to get HPET
Date: Wed, 22 Aug 2007 02:58:24 +0000 (UTC)
Message-ID: <loom.20070822T045428-445@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 70.190.164.204 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.6) Gecko/20070810 Galeon/2.0.2 (Ubuntu package 2.0.2-4ubuntu1) (gutsy) Firefox/2.0.0.6)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have an Acer Ferrari 5000 laptop, it has an AMD64 TL-60 processor, and an
RS480 host bridge. I'm running 2.6.22, I get no HPET.

>From looking at the kernel source, the HPET driver is looking for PNP0103. I see
no PNP0103 entry on my machine, just PNP0100. Searching around, it looks like
kernels running on other RS480 systems are finding HPETs.

http://lists.openwall.net/linux-kernel/2007/03/26/215

Do I need to get Acer to update the BIOS to include a PNP0103 entry? Is there
some way I can force this?

