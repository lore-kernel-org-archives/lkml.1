Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbXLCTyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbXLCTyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXLCTyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:54:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1839 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751696AbXLCTyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:54:12 -0500
Date: Sun, 2 Dec 2007 19:28:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nelson Castillo <nelsoneci@gmail.com>, dmitry@ucw.cz
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Module for keyboard statistics / What should I look at?
Message-ID: <20071202192808.GA5538@ucw.cz>
References: <2accc2ff0711271707o636c060ck7587a259dab92917@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2accc2ff0711271707o636c060ck7587a259dab92917@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-11-27 20:07:16, Nelson Castillo wrote:
> Hi.
> 
> More than 2 years ago I wrote a small non-portable patch [1] to gather
> some statistics
> about keyboard usage[2] ( I show the counters with modulo 10 but still this is a
> security risk. Perhaps some random noise should be added ).

RSI prevention?

> My questions are:
> 
> * What should I read to do this in a module?
> * Is there a better way to to this? (perhaps using /dev/input/... and
> a user-space program) ?

Yep, I think you should be using /dev/input.

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
