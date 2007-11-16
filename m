Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbXKPNXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbXKPNXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 08:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbXKPNXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 08:23:00 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46322 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbXKPNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:23:00 -0500
Date: Fri, 16 Nov 2007 14:22:56 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071116132256.GA19251@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com> <20071030204720.GI8479@gamma.logic.tuwien.ac.at> <47279EF7.3040406@redhat.com> <20071030212213.GA13410@gamma.logic.tuwien.ac.at> <20071030152816.f2e8dd7c.zaitcev@redhat.com> <20071031061552.GH11722@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031061552.GH11722@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Pete, dear all,

On Mi, 31 Okt 2007, preining wrote:
> On Di, 30 Okt 2007, Pete Zaitcev wrote:
> > The difference with huaweiAktBbo.c seems that kernel uses a nonzero length.
> > Can you try zero length with the kernel? It's the second argument to the last.
> 
> I tried with the git patch plus changing the penultimage argument from
> 0x1 to 0.

Ok, did new tests with 2.6.24-rc2:
- with plain kernel the usb-storage modules attaches and detaches
  permanently a virtual cd drive, I stopped after 30+ iterations.

- changing the penultimage argument in the usb_stor_huawei_e220_init
  function from 0x1 to 0 stopped this misbehaviour, but

- with the change from 0x1 to 0 the initialization works automatically.

Can we place change this 0x1 to 0?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
MOLESBY (n.)
The kind of family that drives to the seaside and then sits in the car
with all the windows closed, reading the Sunday Express and wearing
sidcups (q.v.)
			--- Douglas Adams, The Meaning of Liff
