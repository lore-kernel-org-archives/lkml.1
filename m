Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYL1TiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYL1TiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 14:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYL1Thy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 14:37:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:50006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYL1Thx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 14:37:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tsv4QxRKoRxiOX6H0Nkiro+E7kpvjq1tvQ2Iu7ffqlEVzszxlW75ZXhsh1y9FmItfZ
         6/pDewtfQ7rhg1I6UYMiqMn7TuZo/uBSo6elb7HR8DWLy87R/jDzSUsNNjVJys/DJu2w
         2PV79u/L3d2+0Py7U4WVI6sS7ZgYh2E5WMzGI=
Message-ID: <742b1fb30812281137r8774a2fid19498da1bb9071a@mail.gmail.com>
Date: Sun, 28 Dec 2008 20:37:50 +0100
From: "Patrizio Bassi" <patrizio.bassi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] Kernel Panic with ath5k and 2.6.28
Cc: "Kernel," <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20081226163404.c619fa4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <742b1fb30812251218k66a090f6je8c1e0f9d98dffc5@mail.gmail.com>
	 <20081226163404.c619fa4f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/27 Andrew Morton <akpm@linux-foundation.org>
>
> (cc linux-wireless)
>
> On Thu, 25 Dec 2008 21:18:42 +0100 "Patrizio Bassi" <patrizio.bassi@gmail.com> wrote:
>
> > Kernel Panic with ath5k and 2.6.28
> >
> > Hi all,
> >
> > Today i migrated to 2.6.28 and ath5k from 2.6.27 and madwifi.
> > I have a trust speedshare turbo 108mb/s card
> > Connection is ok, even with WPA.
> >
> > The problem i met is when i tried to bridge the wifi and the eth interface.
> >
> > I just rebuild the kernel with the bridge module enabled (builtin) and
> > i got the panic
> > in the picture (http://www.patriziobassi.it/downloads/ath5k_panic.jpg)
>
> That trace doesn't have symbolic information hence it isn't a lot of
> use.  Please set CONFIG_KALLSYMS=y and generate a new one.
>
> > when i try to put the wifi interface up on startup with old script configuration
> >
> > The strange thing is that i'm not adding it to the bridge, i just have
> > it in the kernel and i'm enabling the interface.
> > Eth interface goes up flawlessy.
> > Workaround is to boot the laptop without the card plugged it (pcmcia)
> > or do not compile the bridge into the kernel.
> >
> > Attaching the working config. the broken just has the bridge module enabled.
> >
> > I'm ready to test all the patches/suggestions you may provide.
> >
> > Config is at http://www.patriziobassi.it/downloads/config-2.6.28
> >
>

Hi,

i cannot reproduce anymore when i enabled symbol resolution....
i can run the bridge flawlessy now.

I'll try more and report.

Regards


--
Patrizio Bassi
www.patriziobassi.it
http://piazzadelpopolo.patriziobassi.it
