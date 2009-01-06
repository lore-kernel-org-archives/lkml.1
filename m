Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZAFLjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZAFLjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 06:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbZAFLjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 06:39:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAFLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 06:39:41 -0500
Date: Tue, 6 Jan 2009 09:39:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 5 (multimedia #2)
Message-ID: <20090106093910.1bdd3611@pedra.chehab.org>
In-Reply-To: <20090105120657.f5edf279.randy.dunlap@oracle.com>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
	<20090105120657.f5edf279.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 12:06:57 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 5 Jan 2009 17:35:17 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > This tree will not build a powerpc ppc4xx_defconfig due to a kvm problem.
> > 
> > Changes since 20090102:
> 
> With CONFIG_INPUT=n and
> CONFIG_DVB_DM1105=m
> CONFIG_DVB_FIREDTV=m:
> 
> ERROR: "input_event" [drivers/media/dvb/firesat/firedtv.ko] undefined!
> ERROR: "input_register_device" [drivers/media/dvb/firesat/firedtv.ko] undefined!
> ERROR: "input_free_device" [drivers/media/dvb/firesat/firedtv.ko] undefined!
> ERROR: "input_unregister_device" [drivers/media/dvb/firesat/firedtv.ko] undefined!
> ERROR: "input_allocate_device" [drivers/media/dvb/firesat/firedtv.ko] undefined!
> ERROR: "input_event" [drivers/media/dvb/dm1105/dm1105.ko] undefined!
> ERROR: "input_free_device" [drivers/media/dvb/dm1105/dm1105.ko] undefined!
> ERROR: "input_register_device" [drivers/media/dvb/dm1105/dm1105.ko] undefined!
> ERROR: "input_allocate_device" [drivers/media/dvb/dm1105/dm1105.ko] undefined!
> ERROR: "input_unregister_device" [drivers/media/dvb/dm1105/dm1105.ko] undefined!
> 
Also fixed by the same patch for the previous report. It were just a matter to
make DVB_DM1105 dependent of INPUT.

Cheers,
Mauro
