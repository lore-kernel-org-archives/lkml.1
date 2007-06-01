Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbXFAQDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbXFAQDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757689AbXFAQCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:02:51 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbXFAQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:02:49 -0400
Date: Fri, 1 Jun 2007 09:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Gregor Jasny <gjasny@googlemail.com>,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mark Salyzyn <aacraid@adaptec.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [2/3] 2.6.22-rc3: known regressions v2
Message-Id: <20070601090115.3271a397.akpm@linux-foundation.org>
In-Reply-To: <46600F27.1090202@googlemail.com>
References: <465FED20.3090206@googlemail.com>
	<46600F27.1090202@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007 14:20:55 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> SCSI
> 
> Subject    : aacraid: adapter kernel panic'd fffffffd (kexec)
> References : http://lkml.org/lkml/2007/5/29/491
> Submitter  : Yinghai Lu <yhlu.kernel@gmail.com>
> Handled-By : Salyzyn, Mark <mark_salyzyn@adaptec.com>
>              Vivek Goyal <vgoyal@in.ibm.com>
> Status     : problem is being debugged

Mark's aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch is
known to fix this, so we can move this to "known regressions with patches"
