Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZIGXMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZIGXMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZIGXMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:12:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZIGXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:12:33 -0400
Date: Mon, 7 Sep 2009 20:12:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, swetland@google.com
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090907201205.23173985@caramujo.chehab.org>
In-Reply-To: <20090906052819.GE1324@ucw.cz>
References: <20090903041429.GA29875@kroah.com>
	<20090906052819.GE1324@ucw.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 6 Sep 2009 07:28:19 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > 	  Note, Pavel has been adding some of the Dream hardware
> > 	  drivers, which are separate from the core Android drivers.  I
> > 	  have no objection to those, but they should work to get merged
> > 	  to their "correct" places in the tree in another release or
> > 	  so.
> 
> Well, some of those drivers should be moderately easy (touchscreen),
> but some (camera) will take longer than that. For example camera --
> contains _lots_ of code, and uses obsolete v4l api.

The usage of the obsolete V4L API is a problem since we aren't accepting any
drivers with the old API for a long time, doing large efforts to convert the
few remaining ones to V4L2 API.

This probably means also that they are not using the current V4L framework. Are
they already somewhere at the staging tree?



Cheers,
Mauro
