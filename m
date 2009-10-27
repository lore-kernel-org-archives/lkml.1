Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbZJ0DAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbZJ0DAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZJ0DAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:00:48 -0400
Received: from kroah.org ([198.145.64.141]:34841 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbZJ0DAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:00:48 -0400
Date: Mon, 26 Oct 2009 20:00:39 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091027030039.GA6195@kroah.com>
References: <20091022091333.GA31023@elf.ucw.cz> <20091026234332.GB26583@kroah.com> <20091027001702.GA5019@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027001702.GA5019@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 01:17:03AM +0100, Pavel Machek wrote:
> Hi!
> 
> > > This adds generic_gpio and pmem support, both are needed for other
> > > dream drivers.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > I'd prefer to get the existing code building, before adding new stuff :(
> 
> Well, unfortunately other pieces depend on these.

The pieces already in the tree?  Why are you sending me patches that do
not build?

> I have it building with this patch (but note that it uses -I magic; I
> started to write script rewriting files so that -I is not neccessary,
> but I did not have time to finish it yet).

Ok, should I just delete the whole drivers/staging/dream/ directory as
there seems no goal to get this to build properly?  I've just marked the
code as BROKEN, any chance to get it building again soon?

thanks,

greg k-h
