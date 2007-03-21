Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXCUSXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXCUSXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933353AbXCUSXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:23:31 -0400
Received: from mail.velocity.net ([66.211.211.55]:53205 "EHLO
	mail.velocity.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbXCUSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:23:29 -0400
X-AV-Checked: Wed Mar 21 14:23:28 2007 clean
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests
	(2.6.21-rc2 and 2.6.20)
From: Dale Blount <linux-kernel@dale.us>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <460174EC.8000608@redhat.com>
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com>
	 <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk>
	 <loom.20070321T135132-397@post.gmane.org>  <460174EC.8000608@redhat.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 14:23:27 -0400
Message-Id: <1174501407.14261.34.camel@dale.velocity.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 14:09 -0400, Chuck Ebbert wrote:
> Dale Blount wrote:
> >> I'm puzzled why this is hitting Dan, but no one else has reported
> >> anything. Dan, did 2.6.19 work for you?
> > 
> > Actually, I believe it is happening to me too.  This is on a 4-disk raid5 with
> > one failed disk on two 2-port sata_sil pci controller cards.
> > 
> > The BUG below is from 2.6.20.3, but I will try 2.6.21-rc4 tonight.
> > The disk didn't fail until 2.6.20, so I don't know if 2.6.19 would have worked
> > or not.
> > 
> > 
> 
> Just to be clear: you have a RAID array (what level?) with a failed disk
> and it's giving you the same error that Dan gets?


Yes, the BUG looks to be pretty similar to me.  It's a 4 disk raid5 with
one disk missing (dead and sent in for RMA).

Dale

