Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZGHKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZGHKsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZGHKsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:48:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZGHKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:48:07 -0400
Date: Sat, 4 Jul 2009 04:57:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by
	encrypting page cache
Message-ID: <20090704025755.GA1500@ucw.cz>
References: <87hbxx0wcp.fsf@jeremyms.com> <4A4B0125.2090502@crca.org.au> <87d48k2992.fsf@jeremyms.com> <4A4B27D0.8020906@crca.org.au> <20090704024432.GB1345@ucw.cz> <87hbxn78o6.fsf@jeremyms.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbxn78o6.fsf@jeremyms.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 03:47:53, Jeremy Maitin-Shepard wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> [snip]
> 
> > I believe uswsusp could be used rather easily. Just modify s2disk to
> > encrypt image in ram without writing it out, then decrypt it from ram
> > and resume... it should be interesting hack.
> 
> As far as I understand, that would be completely useless since the image
> that would be encrypted would just be a copy of what would still remain
> in memory.

Yes... so next step would be kernel call that would erase all the
pagecache and anonymous pages. You would still leave some data in
kernel structures, but that would be quite hard to fix. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
