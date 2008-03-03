Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYCCOoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYCCOoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYCCOnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:50 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37142 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYCCOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:49 -0500
Date: Mon, 3 Mar 2008 15:12:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pawel Plociennik <paplociennik@gmail.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
Message-ID: <20080303141203.GB12606@elf.ucw.cz>
References: <200803011409.59526.paplociennik@gmail.com> <200803021859.30473.paplociennik@gmail.com> <3d8471ca0803021005o46f99282l77d412306877607a@mail.gmail.com> <200803022009.04028.paplociennik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803022009.04028.paplociennik@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-03-02 20:09:03, Pawel Plociennik wrote:
> On Sunday 02 March 2008 13:05, Guillaume Chazarain wrote:
> 
> > You mean pid 1, right? ;-)
> Of course that (my brain has been mistaked) :-(
> > 
> > Sure, but chroot should then exec /sbin/init as per the given kernel
> > command line. And then you run a real init.
> > 
> > I cannot try it as I don't have another distribution installed in a
> > subdirectory, but if you could test it we would quickly know if it
> > works or not.
> > 
> You have right.
> I have tested that and it  *works* :-)
> so I thing that my patch is *unnecessary* now :-(

Actually I disagree here. This means that if distro in / breaks, you
will not be able to boot in ditstro in /foo any more :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
