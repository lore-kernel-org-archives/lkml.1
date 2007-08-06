Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbXHFTNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbXHFTNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbXHFTNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:13:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:37555 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623AbXHFTNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:13:17 -0400
In-Reply-To: <1C929A99-BA1D-452C-AD54-66D42DBC8D23@kernel.crashing.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708011002.30962.m.kozlowski@tuxland.pl> <18096.24918.111376.805855@cargo.ozlabs.ibm.com> <200708021214.51705.m.kozlowski@tuxland.pl> <1C929A99-BA1D-452C-AD54-66D42DBC8D23@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <81739136c762bc2c6ef170445d93d30d@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linuxppc-dev@ozlabs.org, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       linux-usb-devel@lists.sourceforge.net
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: 2.6.23-rc1-mm2
Date: Mon, 6 Aug 2007 21:12:27 +0200
To: Kumar Gala <galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Some how your defconfig is targeting a PPC64 box:
>
> CONFIG_PPC64=y
>
> shouldn't be set if you want to build a kernel for a G3 imac.

allyesconfig/allmodconfig select a 64-bit build always.  Maybe
it shouldn't.


Segher

