Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYJMK5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYJMK5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYJMK5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:57:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34875 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYJMK5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:57:02 -0400
Date: Mon, 13 Oct 2008 12:57:00 +0200
From: Pavel Machek <pavel@suse.cz>
To: J?rn Engel <joern@logfs.org>
Cc: Chris Snook <csnook@redhat.com>, Stefan Monnier <monnier@iro.umontreal.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081013105700.GD1729@atrey.karlin.mff.cuni.cz>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com> <20081011143552.GA1556@ucw.cz> <20081012130103.GA14119@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012130103.GA14119@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 11 October 2008 16:35:52 +0200, Pavel Machek wrote:
> > 
> > I don't think ext3 is safe w.r.t. whole eraseblocks disappearing. So
> > if you write data 'nearby' root directory and power fails, bye bye
> > filesystem, and journal will not help.
> 
> No device I've ever seen is that stupid.

I have adata SD flash cards that loose data even normal use, no power
fails needed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
