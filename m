Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXJaGYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXJaGYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXJaGX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:23:59 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36493 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXJaGX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:23:58 -0400
Date: Wed, 31 Oct 2007 07:23:56 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071031062356.GI11722@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com> <20071030204720.GI8479@gamma.logic.tuwien.ac.at> <47279EF7.3040406@redhat.com> <20071030212213.GA13410@gamma.logic.tuwien.ac.at> <20071030152816.f2e8dd7c.zaitcev@redhat.com> <20071031061552.GH11722@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031061552.GH11722@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 31 Okt 2007, preining wrote:
> On Di, 30 Okt 2007, Pete Zaitcev wrote:
> > The difference with huaweiAktBbo.c seems that kernel uses a nonzero length.
> > Can you try zero length with the kernel? It's the second argument to the last.
> 
> I tried with the git patch plus changing the penultimage argument from
> 0x1 to 0.

Hmm, in addition I added a
	printk(KERN_ERR "ENTERING usb_stor_huawei_e220_init!\n");
at the beginning of the function but it never showed up in my log files.
So it seems that the UNUSUAL_DEV entry does not match.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
TIDPIT (n.)
The corner of a toenail from which satisfying little black deposits
may be sprung.
			--- Douglas Adams, The Meaning of Liff
