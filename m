Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbYCFMBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbYCFMBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbYCFL7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:59:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40582 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453AbYCFL7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:59:41 -0500
Date: Thu, 6 Mar 2008 12:53:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wedgwood <cw@f00f.org>, Pawel Plociennik <paplociennik@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306115315.GA8972@elf.ucw.cz>
References: <200803060001.38432.paplociennik@gmail.com> <20080306103422.GA5511@puku.stupidest.org> <20080306104448.GG13391@elte.hu> <20080306112212.GA9261@puku.stupidest.org> <20080306113729.GA18403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306113729.GA18403@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-06 12:37:29, Ingo Molnar wrote:
> 
> * Chris Wedgwood <cw@f00f.org> wrote:
> 
> > > But given an existing initrd (which might have come from the distro, 
> > > etc.) i prefer adding boot options instead of modifying the initrd.
> > 
> > I assume this is so you have have /distro1 /distro2 and use your boot
> > option to (help) select which one you boot into?
> 
> while i have no personal use for chroot=, i generally test distros that 
> way, yes - and i try to keep them as unmodified as possible.
> 
> "Use the initrd as an extended boot commandline" is a poor answer IMO. 
> 
> _Everything_ we do on the boot commandline that affects user-space can 
> be done in an initrd in theory - but still we have hundreds of boot 
> options.

Yes, please. chroot= is useful, nonintrusive, and it just should be there.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
