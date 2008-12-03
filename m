Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbYLCI0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbYLCI0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYLCI0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:26:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40454 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYLCI0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:26:01 -0500
Date: Wed, 3 Dec 2008 09:25:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: jonsmirl@gmail.com, jrm8005@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: In-kernel IR remote control support
Message-ID: <20081203082555.GA1944@ucw.cz>
References: <20081123180146.GA7731@ucw.cz> <Ar6VqEpojFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ar6VqEpojFB@christoph>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-02 19:00:00, Christoph Bartelmus wrote:
> Hi Pavel,
> 
> on 23 Nov 08 at 19:01, Pavel Machek wrote:
> [...]
> >>> support for the common remotes. That seems like a net plus to me, and
> >>> you can still keep the obscure ones in userland.
> >>
> >> Jon's code and the LIRC approach exclude each other. It does not make
> >> sense to have both in the kernel. There have been attempts to clean up
> >> LIRC code to be included in the kernel. The current discussion lessens my
> >> hope that this will happen anytime soon.
> 
> > I don't see why we could not use Jon's code for common remotes decoded
> > mostly by hw, and your code for the obscure cases.
> 
> Ok, how about this:
> there's one common point in lirc_dev where all IR timing data is handled.
> Jon's code can grab the data at this point and feed it into its state  
> machine. That way there's no need to change any of the existing drivers.
> And we all work together to get this stuff ready for inclusion into the  
> kernel.

Yes, that sounds sane.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
