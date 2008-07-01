Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYGAUVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYGAUVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbYGAUUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:20:47 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38038 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbYGAUUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:20:44 -0400
Date: Tue, 1 Jul 2008 22:21:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 08/24] kbuild: make clean removes *.o.* as well
Message-ID: <20080701202131.GA10807@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org> <1214861718-32626-8-git-send-email-sam@ravnborg.org> <alpine.LNX.1.10.0807011409170.12878@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807011409170.12878@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 02:10:26PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2008-06-30 23:35, Sam Ravnborg wrote:
> 
> >From: Alexey Dobriyan <adobriyan@gmail.com>
> >
> >Those are left presumably from aborted ccache(1) compilations:
> >
> >	arch/x86/kernel/.tmp_io_apic_64.o.T5veul
> >	arch/x86/kvm/.tmp_x86.o.SZWn69
> >	arch/x86/mm/.tmp_pgtable.o.sL1LTf
> >	drivers/ieee1394/.tmp_ieee1394_transactions.o.bUj6o1
> >	drivers/infiniband/hw/mlx4/.tmp_main.o.vy0ep6
> 
> I'd suggest using '.tmp_*.o.*' instead of '*.o.*'.

Agreed. Fixed and pushed out a new set of patches.

	Sam
