Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbXJaGtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbXJaGtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXJaGtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:49:13 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44992 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXJaGtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:49:12 -0400
Date: Wed, 31 Oct 2007 07:49:09 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071031064909.GJ11722@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com> <20071030204720.GI8479@gamma.logic.tuwien.ac.at> <47279EF7.3040406@redhat.com> <20071030212213.GA13410@gamma.logic.tuwien.ac.at> <20071030152816.f2e8dd7c.zaitcev@redhat.com> <20071031061552.GH11722@gamma.logic.tuwien.ac.at> <20071031062356.GI11722@gamma.logic.tuwien.ac.at> <20071030234539.aecca9e8.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030234539.aecca9e8.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 30 Okt 2007, Pete Zaitcev wrote:
> This doesn't seem to be possible, considering the /proc/bus/usb/devices
> that you posted. I would rather suspect that you forgot to perform
> some step in your kernel installation, and end using a stale
> usb-storage module.

No.

$ uname -r
2.6.23
$ cd /lib/modules/2.6.23
$ find . -name usb-storage.ko
./kernel/drivers/usb/storage/usb-storage.ko
$ strings ./kernel/drivers/usb/storage/usb-storage.ko | grep -i huawei_e22a
<3>ENTERING usb_stor_huawei_e220_init!
$

So it is there ... and it is the only module.


Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
`The first ten million years were the worst,' said Marvin,
`and the second ten million, they were the worst too. The
third ten million I didn't enjoy at all. After that I went
into a bit of a decline.'
                 --- Marvin reflecting back on his 576,000,003,579 year
                 --- career as Milliways' car park attendent.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
