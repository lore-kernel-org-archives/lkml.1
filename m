Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbXK1RnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbXK1RnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXK1RnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:43:04 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:4263 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbXK1RnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FfxQpNTMsnT/C269gf8m3yETYShQdyvpLhEqckbYAKlFv/CL+AyeOArjIQZfSwV+tHVjP5kNz3aPzw65d3uCPPZWQ1AReshLVH+SvhqPK5vcHI4hiLeEGkkBJw6+lbFBdPs0BGA6QpkfSZfMBY2QUA4trEDXqzr/tyDX5mbBQuQ=
Message-ID: <9e4733910711280943t75564912m805cfdb2fe099528@mail.gmail.com>
Date: Wed, 28 Nov 2007 12:43:00 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: [i2c] [2.6 patch] some overdue I2C driver removal
Cc: "Jean Delvare" <khali@linux-fr.org>,
       "Russell King" <rmk+kernel@arm.linux.org.uk>,
       "Adrian Bunk" <bunk@kernel.org>, i2c@lm-sensors.org,
       "Lennert Buytenhek" <buytenh@wantstofly.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071128173022.GD2308@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162528.GX30533@stusta.de>
	 <20071024164347.GN4003@csclub.uwaterloo.ca>
	 <20071128112357.3828d469@hyperion.delvare>
	 <20071128173022.GD2308@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> On Wed, Nov 28, 2007 at 11:23:57AM +0100, Jean Delvare wrote:
> > There's no driver to write (i2c-gpio is the driver). Instead, the
> > scx200 platform needs to implement the standard GPIO API. I don't think
> > that it has happened yet, and last time this was discussed, someone
> > (can't remember who, sorry), complained that the GPIO API "sucked" and
> > that the scx200 platform would not be updated to use it. I didn't buy
> > the claim due to a lack of argumentation and the fact that the GPIO
> > infrastructure seems to work well enough for many other platforms.
> >
> > As far as I can see, the ixp2000 platform also doesn't implement the
> > standard GPIO API yet, so of the 3 drivers that are about to be
> > removed, only i2c-ixp4xx can be removed without functionality loss at
> > the moment. Lennert, Russell, are there any plans to convert the
> > ixp2000 platform to use the generic GPIO layer?
> >
> > Maybe I shouldn't have added this entry in feature-removal-schedule.txt
> > in the first place: these drivers should ideally be dropped in favor of
> > i2c-gpio, but it can only happen for platforms that implement the
> > standard GPIO API. As I am not the one who will convert these
> > platforms, and some of them might as well never be converted (I don't
> > know how active they are nowadays), there's not much I can do.
>
> Well if I get a chance I might try to do it for the scx200 at some point
> (since I do use it) although given the current i2c driver works just
> fine and I have no need for the rest of the gpio lines what so ever
> there isn't that much insentive to do so yet.
>
> Removing the existing i2c driver would seem like a mistake at this time
> though.

Hasn't their been a one year notice that these drivers were going to
be removed? How about removing them and putting them into a tarball on
the i2c web site with a note explaining about how they need to be
updated to use the gpio driver? Then if someone really wants to use
the old drivers they can use them out of tree.

-- 
Jon Smirl
jonsmirl@gmail.com
