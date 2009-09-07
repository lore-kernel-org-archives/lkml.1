Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZIGPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZIGPzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZIGPzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:55:25 -0400
Received: from fifo99.com ([67.223.236.141]:40299 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbZIGPzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:55:24 -0400
Subject: Re: Staging tree status for the .32 kernel merge
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, swetland@google.com
In-Reply-To: <20090906052819.GE1324@ucw.cz>
References: <20090903041429.GA29875@kroah.com>
	 <20090906052819.GE1324@ucw.cz>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 08:55:39 -0700
Message-Id: <1252338939.2139.21.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 07:28 +0200, Pavel Machek wrote:
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
> 
> Plus, I really need to get recent kernel to boot and then get arch/arm
> pieces merged....

I've got a tree with a lot of the arch/arm/msm pieces isolated, doesn't
boot yet .. I had to drop certain parts like the key pad support since
it had a big generic change attached to it .. It's all part of a git
tree which I can expose if you want to look at it.

Daniel

