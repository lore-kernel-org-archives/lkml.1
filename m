Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbXG2Pxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbXG2Pxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763989AbXG2Pxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:53:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:18317 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763964AbXG2Pxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=V+XhGD/kab4ngBMFCmXhmm0SRQW+3xDk7dhsgxzcNfX3UgJ6PfKAJtKlDB+NFsAkN3PJXyszlDja5cCH/dckJhK+QBuGbhz4KfgSXOFXFWu02Zot30985+rnA0THtrb5Vy4tExl8x6axcr9/8hl38EM03msO684XMxpmG46PIqo=
Message-ID: <46ACB700.6080609@googlemail.com>
Date: Sun, 29 Jul 2007 17:49:20 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: "Berck E. Nash" <flyboy@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1-mm1 compile error in function `acpi_pci_choose_state':
References: <46ACAF0B.1080007@gmail.com>
In-Reply-To: <46ACAF0B.1080007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Berck E. Nash wrote:
> drivers/built-in.o: In function `acpi_pci_choose_state':
> pci-acpi.c:(.text+0xdccf): undefined reference to
> `acpi_pm_device_sleep_state'
> drivers/built-in.o: In function `pnpacpi_suspend':
> core.c:(.text+0x35a7c): undefined reference to `acpi_pm_device_sleep_state'

This patch should fix it :

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/hot-fixes/acpi-revert-d-states-branch-from-jun-17-to-jun-19-for-2623-rc1-mm1.patch
 
