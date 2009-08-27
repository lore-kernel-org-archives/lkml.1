Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbZH0Fjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbZH0Fjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 01:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZH0Fjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 01:39:36 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36047
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZH0Fjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:39:35 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Thu, 27 Aug 2009 00:27:37 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <82k50tjw7u.fsf@mid.bfk.de> <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com>
In-Reply-To: <4A94ACDF.30405@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908270027.38700.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 August 2009 22:32:47 Rik van Riel wrote:
> Pavel Machek wrote:
> >> So, would you be happy if ext3 fsck was always run on reboot (at least
> >> for flash devices)?
> >
> > For flash devices, MD Raid 5 and anything else that needs it; yes that
> > would make me happy ;-).
>
> Sorry, but that just shows your naivete.

Hence wanting documentation properly explaining the situation, yes.

Often the people writing the documentation aren't the people who know the most 
about the situation, but the people who found out they NEED said 
documentation, and post errors until they get sufficient corrections.

In which case "you're wrong, it's actually _this_" is helpful, and "you're 
wrong, go away and stop bothering us grown-ups" isn't.

> Metadata takes up such a small part of the disk that fscking
> it and finding it to be OK is absolutely no guarantee that
> the data on the filesystem has not been horribly mangled.
>
> Personally, what I care about is my data.
>
> The metadata is just a way to get to my data, while the data
> is actually important.

Are you saying ext3 should default to journal=data then?

It seems that the default journaling only handles the metadata, and people 
seem to think that journaled filesystems exist for a reason.

There seems to be a lot of "the guarantees you think a journal provides aren't 
worth anything, so the fact there are circumstances under which it doesn't 
provide them isn't worth telling anybody about" in this thread.  So we 
shouldn't bother journaled filesystems?  I'm not sure what the intended 
argument is here...

I have no clue what the finished documentation on this issue should look like 
either.  But I want to read it.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
