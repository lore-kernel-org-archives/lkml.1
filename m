Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753042AbYLQVsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbYLQVsq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYLQVse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:48:34 -0500
Received: from ns1.suse.de ([195.135.220.2]:58580 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYLQVsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:48:33 -0500
Date: Wed, 17 Dec 2008 13:37:45 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>, Julia Lawall <julia@diku.dk>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from
	platform_driver remove functions
Message-ID: <20081217213745.GC26923@suse.de>
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk> <8bd0f97a0812100928l2c75d373n7eba5aa0cc3882fd@mail.gmail.com> <53806.88.114.236.15.1228947522.squirrel@webmail.movial.fi> <8bd0f97a0812101437r4abb9346p8bc8d512ddc02cde@mail.gmail.com> <20081212051759.GA12563@suse.de> <8bd0f97a0812121300p6c509336pde936b7f8c5ca6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0812121300p6c509336pde936b7f8c5ca6a@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 04:00:02PM -0500, Mike Frysinger wrote:
> On Fri, Dec 12, 2008 at 00:17, Greg KH wrote:
> > On Wed, Dec 10, 2008 at 05:37:42PM -0500, Mike Frysinger wrote:
> >> On Wed, Dec 10, 2008 at 17:18, Vorobiev Dmitri wrote:
> >> >> On Wed, Dec 10, 2008 at 11:26, Julia Lawall wrote:
> >> >>  you'll get a
> >> >> warning in C about the assignment, but you wont get a build failure,
> >> >
> >> > ...unless you compile with -Werror, which frequently the case.
> >>
> >> anyone crazy enough to build with -Werror is crazy enough to send in a fix ;)
> >
> > Hm, have you noted that some arches have that flag enabled in their
> > build?
> 
> i dont see anyone building things beyond a select dir or two (none of
> which contain platform drivers) with -Werror.  where are you seeing
> this ?

Sparc builds add this from what I remember, I've broken their build at
times by adding unnecessary errors and got an inbox full of emails about
it :)

thanks,

greg k-h
