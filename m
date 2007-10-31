Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXJaHu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXJaHu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXJaHuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:50:17 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49206 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbXJaHuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:50:16 -0400
Date: Wed, 31 Oct 2007 08:50:13 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071031075013.GB18971@gamma.logic.tuwien.ac.at>
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
> > 	printk(KERN_ERR "ENTERING usb_stor_huawei_e220_init!\n");
> > at the beginning of the function but it never showed up in my log files.
> > So it seems that the UNUSUAL_DEV entry does not match.
> 
> This doesn't seem to be possible, considering the /proc/bus/usb/devices
> that you posted. I would rather suspect that you forgot to perform

Compiling both -- usb-storage and option/usb-serial -- as modules did
work.

Ok, thanks a lot.

I assume that is because the built-in usb-serial/option did grab the
device so the init function wasn't executed. Putting both into modules
allowed that usb-storage grabbed the device first.

Anyway, my interpretation without any knowledge.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
SCONSER (n.)
A person who looks around then when talking to you, to see if there's
anyone more interesting about.
			--- Douglas Adams, The Meaning of Liff
