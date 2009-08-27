Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbZH0DQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbZH0DQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZH0DQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:16:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59298
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZH0DQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:16:40 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Wed, 26 Aug 2009 22:16:17 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <82k50tjw7u.fsf@mid.bfk.de> <4A93E908.6050908@redhat.com> <20090825144210.7c77c083@lxorguk.ukuu.org.uk>
In-Reply-To: <20090825144210.7c77c083@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908262216.19203.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 August 2009 08:42:10 Alan Cox wrote:
> On Tue, 25 Aug 2009 09:37:12 -0400
>
> Ric Wheeler <rwheeler@redhat.com> wrote:
> > I really think that the expectation that all OS's (windows, mac, even
> > your ipod) all teach you not to hot unplug a device with any file system.
> > Users have an "eject" or "safe unload" in windows, your iPod tells you
> > not to power off or disconnect, etc.
>
> Agreed

Ok, I'll bite: What are journaling filesystems _for_?

> > I don't object to making that general statement - "Don't hot unplug a
> > device with an active file system or actively used raw device" - but
> > would object to the overly general statement about ext3 not working on
> > flash, RAID5 not working, etc...
>
> The overall general statement for all media and all OS's should be
>
> "Do you have a backup, have you tested it recently"

It might be nice to know when you _needed_ said backup, and when you shouldn't 
re-backup bad data over it, because your data corruption actually got detected 
before then.

And maybe a pony.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
