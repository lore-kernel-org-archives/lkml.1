Return-Path: <linux-kernel-owner+w=401wt.eu-S1751179AbZGYETb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbZGYETb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 00:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbZGYETb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 00:19:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40743 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZGYETa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 00:19:30 -0400
Date: Sat, 25 Jul 2009 14:18:56 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Greg KH <gregkh@suse.de>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       webmaster@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: Linux 2.6.27.28
Message-ID: <20090725041856.GA21123@brong.net>
References: <20090724222746.GA30562@kroah.com>
 <4A6A48A1.80608@tremplin-utc.net>
 <20090725033030.GA481@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090725033030.GA481@suse.de>
Organization: brong.net
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 08:30:30PM -0700, Greg KH wrote:
> On Sat, Jul 25, 2009 at 01:49:53AM +0200, Éric Piel wrote:
> > Currently, there is no clue on www.kernel.org that 2.6.27 is a "long
> > term stable" kernel tree. Would it be possible to add a line to the page
> > pointing to the latest version of this type of tree? I'm sure some
> > people would love discovering that such thing exists :-)
> 
> I'm curious as to why someone, if they were inclined to be using such a
> thing, wouldn't already know about this?
> 
> How many people really are relying on this .27 branch, becides the
> distros, these days?  And if you are, why?

We had some instability with .29, and it was annoying enough that I've
"standardised" on 2.6.27.25 across all the new installs of our servers
(largely because that was current back when I build those packages a
couple of weeks ago) - and since I'm reinstalling everything with the
shiny new Debian Lenny personality, we're running .27 on most of our
servers now.

I'm a little cautious about .30 because of the reiserfs changes that went
in.  All our customer data is on reiserfs partitions, and I want to take
it nice and slow testing it...

Er, that about covers it I think.  We'll probably jump to .30 or .31 at
some point.

Oh, yeah.  Bloody ipssend.  If anyone from IBM is reading this, can you
please hit your software distribution people over the head with a big
fat cluebat and provide your raid management tools as a single download
somewhere that's not a self extracting windows executable floppy image or
a .iso containing a self extracting windows executable floppy image, or...
you get the picture.  It's a disgrace.  And while you're at it, build an
ipssend that works with kernels 2.6.28+.  Thanks.

Bron.
