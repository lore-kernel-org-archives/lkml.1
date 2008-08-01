Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbYHAWTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbYHAWTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbYHAWTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:19:10 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:55150
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbYHAWTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:19:09 -0400
X-Trace: 118059334/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAO8ok0jDlSwG/2dsb2JhbACBW4lEpSo
X-IronPort-AV: E=Sophos;i="4.31,295,1215385200"; 
   d="scan'208";a="118059334"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: linasvepstas@gmail.com
Subject: Re: amd64 sata_nv (massive) memory corruption
Date: Fri, 1 Aug 2008 23:19:04 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc1-damocles; KDE/4.1.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
In-Reply-To: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808012319.05038.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2008 18:30:34 Linas Vepstas wrote:
> Hi,
>
> I'm seeing strong, easily reproducible (and silent) corruption on a
> sata-attached
> disk drive on an amd64 board.  It might be the disk itself, but I
> doubt it; googling
> suggests that its somehow iommu-related but I cannot confirm this.

Nowhere do you explicitly say you have memtest86'ed the RAM. Checking 4GB of 
RAM will take some time (probably several hours) but it will mostly eliminate 
bad memory as the cause of the corruption.

IME these kinds of bugs are almost always bad RAM. Since the part of the RAM 
that is bad may never be used by kernel code, you may experience no crashes. 
This is especially true of machines with a lot of RAM. However since your 
filesystem cache can easily consume all 4GB over time, you could see this kind 
of corruption when copying files.

-- 
Cheers,
Alistair.
