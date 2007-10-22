Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXJVVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXJVVu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbXJVVuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:50:16 -0400
Received: from 133.90.227.87.static.ehn.siw.siwnet.net ([87.227.90.133]:59104
	"EHLO 133.90.227.87.static.ehn.siw.siwnet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbXJVVuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:50:14 -0400
Date: Mon, 22 Oct 2007 23:50:10 +0200
From: Henrik Carlqvist <hc1@poolhem.se>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-Id: <20071022235010.08021506.hc1@poolhem.se>
In-Reply-To: <471C8DA3.9070900@aitel.hist.no>
References: <200710201257.55616.nick@ukfsn.org>
	<20071020144238.4f258c8c.hc1@poolhem.se>
	<471C8DA3.9070900@aitel.hist.no>
X-Mailer: Sylpheed version 0.9.2 (GTK+ 1.2.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 13:46:43 +0200
> > In that kernel CONFIG_SCSI_QLA_FC is set to y but still it is not
> > possible to boot from any of those cards as the driver requires a
> > firmware file. 
> Then an initrd-less boot is impossible for this
> device - even the modular approach needs
> an initrd to load the module if you want that
> device as root fs.

Today I was able to boot from an FC disk with a modified kernel 2.6.21
without any initrd. The modification was basically to replace the contents
of drivers/scsi/qla2xxx with the code in qla2xxx-v8.02.02-dist.tgz from
ftp://ftp.qlogic.com/outgoing/linux/beta/8.x/ as that driver has the
firmware built in.

> Better to just fix the driver - which can't be that
> hard for anyone capable of making the driver in
> the first place. Modularity and firmware loading
> are not connected. One is for kernel flexibility, the other
> is for making a particular device work.

In this case I finally did prefer a solution which didn't depend on any
separate firmware file. Being able to boot straight to the FC drive
without the need of initrd was really nice.

When I first asked my question I assumed that I would have to compile the
driver as a module and use an initrd containing both the module and the
firmware together with userspace mechanisms to load the firmware. This
solution with a replaced qla2xxx driver was not the answer to my first
question about bool and tristate, but that question also got answered in
this thread.

Best regards Henrik
