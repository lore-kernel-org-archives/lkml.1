Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbYBFAP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbYBFAP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760091AbYBFAPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:15:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:54825 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759971AbYBFAPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:15:13 -0500
Date: Wed, 6 Feb 2008 01:15:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Marcel Holtmann <marcel@holtmann.org>, David Sterba <dsterba@suse.cz>,
       linux-kernel@vger.kernel.org, Ben Martel <benm@symmetric.co.nz>,
       stephen@symmetric.co.nz
Subject: Re: [PATCH][v4] ipwireless: driver for 3G PC Card
In-Reply-To: <alpine.LFD.1.00.0802051600330.2967@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802060110540.30955@jikos.suse.cz>
References: <20080201153707.GA24859@ds.suse.cz>  <Pine.LNX.4.64.0802051114390.30955@jikos.suse.cz>
 <1202255212.15090.180.camel@violet> <alpine.LFD.1.00.0802051600330.2967@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Linus Torvalds wrote:

> And especially with wireless, I think the impact for any future changes 
> are about the wireless infrastructure, not PCMCIA. There's little reason 
> to believe that we'll ever make any big PCMCIA overhauls exctly because 
> PCMCIA is so dead. So I'd happily merge it, but I would be even happier 
> if I got ack's from the wireless people or if it was simply merged that 
> way too.

Unfortunately the device has quite confusing name (and the driver of 
course follows). It has 'wireless' in its name, but it has literally 
nothing to do with "wireless" networking, as long as 802.11<anything> is 
involved.

It is in fact a PCMCIA card, that acts as a GPRS/EDGE/UMTS modem. So its 
This has been already discussed, please see 
http://www.ussg.iu.edu/hypermail/linux/kernel/0711.3/2198.html

Thanks,

-- 
Jiri Kosina
SUSE Labs
