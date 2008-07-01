Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYGAMKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYGAMKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYGAMK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:10:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54626 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYGAMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:10:27 -0400
Date: Tue, 1 Jul 2008 14:10:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 08/24] kbuild: make clean removes *.o.* as well
In-Reply-To: <1214861718-32626-8-git-send-email-sam@ravnborg.org>
Message-ID: <alpine.LNX.1.10.0807011409170.12878@fbirervta.pbzchgretzou.qr>
References: <20080630213155.GA32479@uranus.ravnborg.org> <1214861718-32626-8-git-send-email-sam@ravnborg.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-06-30 23:35, Sam Ravnborg wrote:

>From: Alexey Dobriyan <adobriyan@gmail.com>
>
>Those are left presumably from aborted ccache(1) compilations:
>
>	arch/x86/kernel/.tmp_io_apic_64.o.T5veul
>	arch/x86/kvm/.tmp_x86.o.SZWn69
>	arch/x86/mm/.tmp_pgtable.o.sL1LTf
>	drivers/ieee1394/.tmp_ieee1394_transactions.o.bUj6o1
>	drivers/infiniband/hw/mlx4/.tmp_main.o.vy0ep6

I'd suggest using '.tmp_*.o.*' instead of '*.o.*'.
