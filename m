Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYGZSTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYGZSTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYGZSTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:19:06 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:39472 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYGZSTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:19:05 -0400
Subject: Re: Problem mounting Motorola USB device
From: Alan <alan@clueserver.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20080726112249.1ade4980.zaitcev@redhat.com>
References: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
	 <20080725235122.0e097f1f.akpm@linux-foundation.org>
	 <20080726112249.1ade4980.zaitcev@redhat.com>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 11:19:07 -0700
Message-Id: <1217096347.5892.1.camel@rotwang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 11:22 -0600, Pete Zaitcev wrote:
> On Fri, 25 Jul 2008 23:51:22 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > (cc linux-usb-devel)
> > 
> > On Wed, 16 Jul 2008 10:32:31 -0700 (PDT) "Alan" <alan@clueserver.org> wrote:
> 
> > > [...] The device gives an odd media error at towards
> > > the end of the device.  It gave that before, but would still mount.
> 
> Weird. Actually, I would rather blame the partitioning code than
> the usb-storage as such.
> 
> > > [...] I know I probably need a new memory card.  I
> > > would like to recover this one first.
> 
> Want a practical suggestion? Try to stick the card into a common
> many-in-one reader, a SanDisk SDDR-somenumber would usually work.
> Save the data.

This actually causes a kernel oops.  I will post debug info soon.

> 
> > > sd 6:0:0:0: Attached scsi generic sg2 type 0
> > > sd 6:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> > > sd 6:0:0:0: [sdb] Sense Key : Medium Error [current]
> > > sd 6:0:0:0: [sdb] Add. Sense: No additional sense information
> 
> Well, duh.
> 
> BTW Andrew added:
> 
> > It's a 2.6.24 -> 2.6.25 regression.
> 
> Maybe in FAT... See the sector number (1987576).
> 
> BTW, all Fedora kernels have usbmon enabled. May I see the trace?
> Best of all, take the one from the working 2.6.24 (if such install
> is still available). It would become obvious if usb-storage began to
> do something different.
> 
> Obligatory notice: I don't think ub would fix this.

I will get more info now that OSCON is over.

