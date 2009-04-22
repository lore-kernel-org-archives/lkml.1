Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZDVLJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZDVLJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZDVLJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:09:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50313 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZDVLJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:09:23 -0400
Date: Wed, 22 Apr 2009 05:09:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, linux-usb <linux-usb@vger.kernel.org>,
       usb-storage@lists.one-eyed-alien.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
Message-ID: <20090422110921.GE1926@parisc-linux.org>
References: <1240347174.10627.20.camel@nimitz> <20090421211858.GA1926@parisc-linux.org> <1240351210.10627.30.camel@nimitz> <49EEC82B.5040603@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EEC82B.5040603@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 10:32:59AM +0300, Boaz Harrosh wrote:
> These are actually aligned access it might be worth sacrificing a cast
> to be32/64 for sake of speed.

"for sake of speed"?  How often do you think we ask a device how large
it is?  How much overhead do you think is incurred by the unaligned code
if the data happens to be aligned?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
