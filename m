Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYC0LzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYC0LzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYC0LzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:55:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36626 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbYC0LzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:55:09 -0400
Date: Thu, 27 Mar 2008 12:54:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: Re: [PATCH 15/20] x86: move dma_supported and dma_set_mask to
	pci-dma_32.c
Message-ID: <20080327115433.GA13538@elte.hu>
References: <1206480999-21767-8-git-send-email-gcosta@redhat.com> <1206480999-21767-9-git-send-email-gcosta@redhat.com> <1206480999-21767-10-git-send-email-gcosta@redhat.com> <1206480999-21767-11-git-send-email-gcosta@redhat.com> <1206480999-21767-12-git-send-email-gcosta@redhat.com> <1206480999-21767-13-git-send-email-gcosta@redhat.com> <1206480999-21767-14-git-send-email-gcosta@redhat.com> <1206480999-21767-15-git-send-email-gcosta@redhat.com> <1206480999-21767-16-git-send-email-gcosta@redhat.com> <1206615795.31683.8.camel@muff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206615795.31683.8.camel@muff>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark McLoughlin <markmc@redhat.com> wrote:

> This breaks for me with:
> 
> ERROR: "dma_supported" [drivers/ssb/ssb.ko] undefined!
> ERROR: "dma_set_mask" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
> ERROR: "dma_set_mask" [drivers/scsi/aic7xxx/aic7xxx.ko] undefined!
> ERROR: "dma_set_mask" [drivers/scsi/aic7xxx/aic79xx.ko] undefined!
> ERROR: "dma_supported" [drivers/net/pcnet32.ko] undefined!
> ERROR: "dma_supported" [drivers/media/video/saa7134/saa7134.ko] undefined!
> ERROR: "dma_set_mask" [drivers/media/video/meye.ko] undefined!
> ERROR: "dma_supported" [drivers/media/video/cx88/cx8802.ko] undefined!
> ERROR: "dma_supported" [drivers/media/video/cx88/cx8800.ko] undefined!
> ERROR: "dma_supported" [drivers/media/video/cx88/cx88-alsa.ko] undefined!
> ERROR: "dma_supported" [drivers/media/video/cx23885/cx23885.ko] undefined!
> 
> They just need to be exported like on x86_64.

thanks Mark, applied.

	Ingo
