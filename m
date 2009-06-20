Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZFTTGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZFTTGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZFTTGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:06:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36329 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZFTTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:06:29 -0400
Date: Sat, 20 Jun 2009 13:06:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: jim owens <jowens@hp.com>, Martin Knoblauch <knobi@knobisoft.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, mike.miller@hp.com, linux-pci@vger.kernel.org
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090620190630.GN19977@parisc-linux.org>
References: <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> <971371.70253.qm@web32604.mail.mud.yahoo.com> <4A3D104E.9060105@hp.com> <20090620165853.GL19977@parisc-linux.org> <ac3eb2510906201119r5c528a3s67cd04bdbfdd1d9c@mail.gmail.com> <20090620182617.GM19977@parisc-linux.org> <ac3eb2510906201136v4c6eac1bwffd2aed3e38c6ae1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510906201136v4c6eac1bwffd2aed3e38c6ae1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 08:36:25PM +0200, Kay Sievers wrote:
> Ah, I see. There is no tool around udev, I know of, which does this.
> 
> Maybe someone is still using the broken-by-design libsysfs, which
> opens _every_ file it can find in /sys, even when not asked for
> anything specific.

I did consider that option, but dismissed it ... I didn't think anyone
was using something that old.  Martin, could you take a look at what
scripts you're running?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
