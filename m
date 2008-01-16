Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYAPLvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYAPLvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYAPLvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:51:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42769 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753810AbYAPLvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:51:38 -0500
Date: Wed, 16 Jan 2008 12:51:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@google.com>
Cc: David Chinner <dgc@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
       Valerie Henson <val.henson@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080116115144.GE22460@elf.ucw.cz>
References: <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com> <20080115230714.GC3573@elf.ucw.cz> <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-01-15 18:44:26, Daniel Phillips wrote:
> On Jan 15, 2008 6:07 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > I had write cache enabled on my main computer. Oops. I guess that
> > means we do need better documentation.
> 
> Writeback cache on disk in iteself is not bad, it only gets bad if the
> disk is not engineered to save all its dirty cache on power loss,
> using the disk motor as a generator or alternatively a small battery.
> It would be awfully nice to know which brands fail here, if any,
> because writeback cache is a big performance booster.

Is it?

I guess I should try to measure it. (Linux already does writeback
caching, with 2GB of memory. I wonder how important disks's 2MB of
cache can be).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
