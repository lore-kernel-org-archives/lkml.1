Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZDKVLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZDKVLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 17:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZDKVKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 17:10:54 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:58057 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZDKVKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 17:10:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18913.1720.994638.274611@stoffel.org>
Date: Sat, 11 Apr 2009 17:08:08 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <49E0F581.6010901@garzik.org>
References: <49E0D47B.9070205@garzik.org>
	<20090411203246.513a0892@lxorguk.ukuu.org.uk>
	<49E0F581.6010901@garzik.org>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeff" == Jeff Garzik <jeff@garzik.org> writes:

Jeff> Alan Cox wrote:

>>> With a brand new command set, might as well avoid SCSI completely
>>> IMO, and create a brand new block device.
>> 
>> Providing we allow for the (inevitable ;)) joys of NVHCI over SAS etc 8)

Jeff> Perhaps...  from what I can tell, this is a direct, asynchronous
Jeff> NVM interface.  It appears to lack any concept of bus or bus
Jeff> enumeration.  No worries about link up/down, storage device
Jeff> hotplug, etc.  (you still have PCI hotplug case, of course)

Didn't we just spend years merging the old IDE PATA block devices into
the libata/scsi block device setup to get a more unified userspace and
to share common code?  

I'm a total ignoramous here, but it would seem that it would be nice
to keep the /dev/sd# stuff around for this, esp since it is supported
through/with/around AHCI and libata stuff.

Honestly, I don't care as long as userspace isn't too affected and I
can just format it using ext3.  :]  Which I realize would be silly
since it's probably nothing like regular disk access, but more like
the NVRAM used on Netapps for caching writes to disk so they can be
acknowledged quicker to the clients.  Or like the old PrestoServe
NVRAM modules on DECsystems and Alphas.  

John
