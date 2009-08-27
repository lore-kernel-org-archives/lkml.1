Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZH0DfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZH0DfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZH0DfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:35:16 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44841
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbZH0DfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:35:12 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Wed, 26 Aug 2009 22:34:52 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <20090824093143.GD25591@elf.ucw.cz> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu>
In-Reply-To: <20090825000842.GM17684@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908262234.54586.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 August 2009 19:08:42 Theodore Tso wrote:
> And if your
> claim is that several hundred lines of fsck output detailing the
> filesystem's destruction somehow makes things all better, I suspect
> most users would disagree with you.

Suppose a small office makes nightly backups to an offsite server via rsync.  If 
a thunderstorm goes by causing their system to reboot twice in a 15 minute 
period, would they rather notice the filesystem corruption immediately upon 
reboot, or notice after the next rsync?

> In any case, depending on where the flash was writing at the time of
> the unplug, the data corruption could be silent anyway.

Yup.  Hopefully btrfs will cope less badly?  They keep talking about 
checksumming extents...

> Maybe this came as a surprise to you, but anyone who has used a
> compact flash in a digital camera knows that you ***have*** to wait
> until the led has gone out before trying to eject the flash card.

I doubt the cupholder crowd is going to stop treating USB sticks as magical 
any time soon, but I also wonder how many of them even remember Linux _exists_ 
anymore.

> I
> remember seeing all sorts of horror stories from professional
> photographers about how they lost an important wedding's day worth of
> pictures with the attendant commercial loss, on various digital
> photography forums.  It tends to be the sort of mistake that digital
> photographers only make once.

Professionals have horror stories about this issue, therefore documenting it 
is _less_ important?

Ok...

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
