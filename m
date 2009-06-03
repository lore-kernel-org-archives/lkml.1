Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZFCUVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZFCUVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZFCUVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:21:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35907 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZFCUVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:21:42 -0400
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg
	list  with different entry count [map count=13] [unmap count=10]
From: Kasper Sandberg <lkml@metanurb.dk>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
In-Reply-To: <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com>
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
	 <4A1C7DDB.9010605@gmail.com>
	 <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 22:21:43 +0200
Message-Id: <1244060503.11698.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-03 at 21:30 +0200, Torsten Kaiser wrote:
> On Wed, May 27, 2009 at 1:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> > Torsten Kaiser wrote:
> >>
> >> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
> >> CONFIG_DMA_API_DEBUG=y
> >> Since then I get the following or similar errors on each boot:
> >
> > Please retest with a newer -rc, this patch likely fixes it:
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
> >
> 
> Still happens with 2.6.30-rc8 (see trace at the end of the email)
> 
<snip>

Does this actually give you any problems? should I be scared to give .30
a test?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

