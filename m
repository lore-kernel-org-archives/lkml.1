Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbXKYR07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbXKYR07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 12:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXKYR01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 12:26:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3590 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753413AbXKYR0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:26:25 -0500
Date: Fri, 23 Nov 2007 14:28:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Treat disk space like memory space
Message-ID: <20071123142817.GA10859@ucw.cz>
References: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So I'd like to be able to say "these areas of my file-system hold data
> that you can discard whenever you need space".  So I can freely fill up
> my disk with such irrelevant data, safe in the knowledge that if I ever
> need this disk space it'll be automatically reclaimed.
> 
> [ I realize this is probably better implemented outside of the kernel, but
>   it seems like it might be of interest here.  Please redirect me to
>   a more appropriate place if you can think of one (other than
>   /dev/null that is).  ]

Actually, you'll probably need fs hooks for reliable operation. And
yes, someone finally implementing this would be welcome :-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
