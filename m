Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbXJSKRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbXJSKRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXJSKRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:17:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56915 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbXJSKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:17:39 -0400
Date: Fri, 19 Oct 2007 12:17:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Rik van Riel <riel@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: OOM notifications
Message-ID: <20071019101743.GA24354@elf.ucw.cz>
References: <20071018202504.GA2854@dmt> <4717C43D.6030204@keyaccess.nl> <20071018165238.0537eaa6@bree.surriel.com> <4717CAEC.50203@keyaccess.nl> <20071018171857.409255de@bree.surriel.com> <4717D7B6.40102@keyaccess.nl> <4717D9BF.4010508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4717D9BF.4010508@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-10-18 15:10:07, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Rene Herman wrote:
> > That first threshold sounds fine yes. To me, the second mostly sounds
> > like a job for SIGTERM though.
> 
> I agree.  Applications shouldn't be expected to be yet more complicated
> and have different levels of low memory handling.  You might want to
> give a process a second shot at handling SIGDANGER but after that's it's
> all about preparation for a shutdown.

That works okay on a PC, but try cellphone one day.

You want management app to close the least used application. You do
not want _kernel_ to select "who to send SIGTERM to".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
