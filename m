Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZAaKOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZAaKOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZAaKN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:13:57 -0500
Received: from sov-mail-b0014.gradwell.net ([193.84.87.38]:53822 "EHLO
	sov-mail-b0014.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbZAaKN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:13:56 -0500
Date: Sat, 31 Jan 2009 10:05:16 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27 & ext4 strangeness
Message-ID: <20090131100516.01adc593@lithium.local.net>
In-Reply-To: <20090131000917.GB27950@mit.edu>
References: <20090130194702.5a2ca774@lithium.local.net>
	<20090131000917.GB27950@mit.edu>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 19:09:17 -0500, I waved a wand and this message
magically appears in front of Theodore Tso:

> On Fri, Jan 30, 2009 at 07:47:02PM +0000, Alex Buell wrote:
> > 
> > As this has happened three times in the last 24 hours, I thought I'd
> > report this. Whenever my laptop locks up, I have to powercycle.
> > After rebooting, and fsck.ext4 reports a clean filesystem, often I
> > get a 'no space on device' error even though I have plenty of disk
> > space left. Another reboot with a forced fsck.ext4 cures this,
> > every time. This only happens with ext4 filesystems used as the
> > root filesystem. 
> 
> If you can reproduce this, can you send me the output of "df /; df -i
> /; dumpe2fs /dev/XXX" (where XXX is your root device) before you
> reboot and force an fsck?  And then can you send me the output of "df
> / ; df -i /; dumpe2fs /dev/XXX" after the 2nd reboot and forced fsck.
> I've never seen anything like this, so I don't know what to make of
> it.

It's happened again this morning before your e-mail arrived. I'm now
sure I can reproduce it every time the laptop locks up. The next
time it happens I'll do as you request. 

Regards
Alex
-- 
http://www.munted.org.uk

Fearsome grindings.
