Return-Path: <linux-kernel-owner+w=401wt.eu-S935379AbXG3IvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935379AbXG3IvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbXG3Iu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:50:58 -0400
Received: from pauline.vellum.cz ([89.250.243.234]:40200 "EHLO
	pauline.vellum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764AbXG3Iu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:50:57 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 04:50:57 EDT
Date: Mon, 30 Jul 2007 10:41:16 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [BUG] i386 relocable kernel breakes /proc/kcore debugging
Message-ID: <20070730084116.GA18263@host0.dyn.jankratochvil.net>
References: <200707280443.44048.maximlevitsky@gmail.com> <20070730080303.GA6071@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730080303.GA6071@in.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 10:03:03 +0200, Vivek Goyal wrote:
> On Sat, Jul 28, 2007 at 04:43:43AM +0300, Maxim Levitsky wrote:
...
> > gdb 'thinks' that all kernel symbols are below 0x80000000 , while they are at 
> > 0xC000....
> > 
> > Turning CONFIG_RELOCATABLE off fixes that, so I assume that is the reason for 
> > that.
> 
> This is a gdb issue. I had raised it in gdb mailing list some time back.
> 
> http://sourceware.org/ml/gdb/2006-08/msg00137.html

There was the patch post:
	http://sources.redhat.com/ml/gdb/2006-08/msg00182.html

> What version of gdb you are using? I know it got fixed for gdb shipped
> with RHEL5. I am not sure about what upstream version of gdb it got fixed
> in.

It did not make it to the upstream as the patch above is an imperfect one.
It is fixed in RH gdb-6.5-5 upwards, therefore Fedora 6 + RHEL-5.
	http://cvs.fedora.redhat.com/viewcvs/*checkout*/devel/gdb/gdb-6.5-bz203661-emit-relocs.patch?root=core


Regards,
Jan
