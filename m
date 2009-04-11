Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZDKVdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZDKVdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 17:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZDKVdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 17:33:12 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:58115 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbZDKVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 17:33:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18913.3106.750732.50314@stoffel.org>
Date: Sat, 11 Apr 2009 17:31:14 -0400
From: "John Stoffel" <john@stoffel.org>
To: "John Stoffel" <john@stoffel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <18913.1720.994638.274611@stoffel.org>
References: <49E0D47B.9070205@garzik.org>
	<20090411203246.513a0892@lxorguk.ukuu.org.uk>
	<49E0F581.6010901@garzik.org>
	<18913.1720.994638.274611@stoffel.org>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

>>>>> "Jeff" == Jeff Garzik <jeff@garzik.org> writes:
Jeff> Alan Cox wrote:

>>>> With a brand new command set, might as well avoid SCSI completely
>>>> IMO, and create a brand new block device.
>>> 
>>> Providing we allow for the (inevitable ;)) joys of NVHCI over SAS etc 8)

Jeff> Perhaps...  from what I can tell, this is a direct, asynchronous
Jeff> NVM interface.  It appears to lack any concept of bus or bus
Jeff> enumeration.  No worries about link up/down, storage device
Jeff> hotplug, etc.  (you still have PCI hotplug case, of course)

John> Didn't we just spend years merging the old IDE PATA block devices into
John> the libata/scsi block device setup to get a more unified userspace and
John> to share common code?  

John> I'm a total ignoramous here, but it would seem that it would be nice
John> to keep the /dev/sd# stuff around for this, esp since it is supported
John> through/with/around AHCI and libata stuff.

John> Honestly, I don't care as long as userspace isn't too affected and I
John> can just format it using ext3.  :]  Which I realize would be silly
John> since it's probably nothing like regular disk access, but more like
John> the NVRAM used on Netapps for caching writes to disk so they can be
John> acknowledged quicker to the clients.  Or like the old PrestoServe
John> NVRAM modules on DECsystems and Alphas.  

And actually spending some thought on this, I'm thinking that this
will be like the MTD block device and such... seperate specialized
block devices, but still usable.  So maybe I'll just shutup now.  :]

John
