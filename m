Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZH2Veq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZH2Veq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 17:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZH2Veo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 17:34:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44265 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZH2Vel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 17:34:41 -0400
Date: Sat, 29 Aug 2009 23:34:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rob Landley <rob@landley.net>
Cc: david@lang.hm, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090829213432.GC1375@ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm> <20090829100558.GH1634@ucw.cz> <200908291522.07694.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908291522.07694.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-08-29 15:22:06, Rob Landley wrote:
> On Saturday 29 August 2009 05:05:58 Pavel Machek wrote:
> > On Fri 2009-08-28 07:49:38, david@lang.hm wrote:
> > > On Thu, 27 Aug 2009, Rob Landley wrote:
> > >> Pavel's response was to attempt to document this.  Not that journaling
> > >> is _bad_, but that it doesn't protect against this class of problem.
> > >
> > > I don't think anyone is disagreeing with the statement that journaling
> > > doesn't protect against this class of problems, but Pavel's statements
> > > didn't say that. he stated that ext3 is more dangerous than ext2.
> >
> > Well, if you use 'common' fsck policy, ext3 _is_ more dangerous.
> 
> The filesystem itself isn't more dangerous, but it may provide a false sense of 
> security when used on storage devices it wasn't designed for.

Agreed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
