Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0BLXOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:14:51 -0500
Received: from 1wt.eu ([62.212.114.60]:56351 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab0BLXOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:14:50 -0500
Date: Sat, 13 Feb 2010 00:14:19 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Sleddens, J.P.G." <j.p.g.sleddens@hro.nl>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, mirrors@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] [kernel.org mirrors] XZ Migration	discussion
Message-ID: <20100212231419.GB10266@1wt.eu>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <4B75A5FE.8020408@zytor.com> <4B75C8CB.DBDA.0014.0@hro.nl> <4B75D1F9.5070501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B75D1F9.5070501@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 02:11:05PM -0800, H. Peter Anvin wrote:
> On 02/12/2010 12:31 PM, Sleddens, J.P.G. wrote:
> >>>> On 12-2-2010 at 20:03, "H. Peter Anvin" <hpa@zytor.com> wrote:
> >> On 02/12/2010 06:01 AM, Jean Delvare wrote:
> >>> 3* Create a new subdirectory for every 2.6.x kernel, and move all the
> >>> related files there. This would shrink the main index drastically, and
> >>> each subdirectory would have a reasonable size (except maybe 2.6.16 and
> >>> 2.6.27.) Oddly enough this has been done for the files under testing/
> >>> already, so I am curious why we don't do it for the release files (and
> >>> the testing/incr/ files, while we're at it.)
> >>
> >> Well, part of the reason why is that we're functionally "stuck" on 2.6;
> >> a prefix which really has lost all meaning.
> >>
> >> It might open up the question if we shouldn't just do a Solaris and drop
> >> the leading 2 (so the next kernel would be 6.33) or call the kernel
> >> after that 3.0 instead of 2.6.34, and then 3.1 instead of 2.6.35.
> > 
> > I remember the whole LKML discussion about this a few years back:
> > http://lkml.org/lkml/2008/10/15/377 
> > 
> > The whole year.version   or year/month versioning Greg HK proposed
> > made a lot of sense to me.  It would also solve our problem with the 2.6
> > directory just growing and growing as the year versioning would make a
> > natural hierarchy which keeps going no matter what.
> 
> Note also that every time this conversation happens it starts to pull
> away in different directions, and as a result nothing happens.
> 
> I'm going to stick my foot in it and state the following: I think
> incremental numbers work well, and everyone are used to them.  It
> doesn't seem to be the major issue with the current scheme; the issue
> with the current scheme is that we have one or two levels too much.

Exactly. And for having worked with projects using dates, it's a hell
complicated to handle delayed releases... I'd like 3.0, 3.1, ... too,
and am using that scheme for my projects, which people easily understand
very well, as opposed to x.y.z.t.

But now I think that Linus has a "grep -v 3.0" filter on his inbox, I
never got a reply from him on the subject and I know I'm not the only
one :-(

Willy

