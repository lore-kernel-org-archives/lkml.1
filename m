Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970Ab0ANBB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0ANBB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825Ab0ANBB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:01:56 -0500
Received: from comsrv.aao.GOV.AU ([192.231.167.2]:33452 "HELO
	comsrv.aao.gov.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754652Ab0ANBBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:01:55 -0500
Date: Thu, 14 Jan 2010 12:03:36 +1100
From: Scott Smedley <ss@aao.gov.au>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Message-ID: <20100114010335.GB20569@aao.gov.au>
Reply-To: ss@aao.gov.au
References: <201001122242.22774.mitov@issp.bas.bg> <20100112235221.GA20761@aao.gov.au> <20100113001724.GB29904@kroah.com> <201001130816.43855.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001130816.43855.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg & Marin,

> > Scott, any comparison between the two of them as to which one actually
> > works better?

I'd be interested in Marin's opinion as he appears to have used both
drivers extensively.

I'd like a userspace program to actually try out Marin's driver, but
I can still make some general comments:

Things I like about Marin's driver:
- It is only ~1/3rd the size. (by counting new lines)
- The code is much neater.
- It can acquire frames at 25 fps (real-time), according to Marin.
- At least 1 person with intimate knowledge of the code seems keen to
  maintain it.

Things I like about the sourceforge (SF) driver:
- It works in CCIR mode (768x576) or 640x480 mode.
- It is well tested.
- It works with most kernel versions. ie. 2.2, 2.4, & 2.6. (mostly)
- It works with multiple boards.
- The code is moderately well commented.
- It includes simple (user space) example programs.


Clearly each driver has strengths over the other.

It would probably be easier to upgrade Marin's driver to match the
strengths of the SF driver than the other way around. The only
difficulty might be in making Marin's driver work with older kernel
versions. IMO, that's probably an acceptable sacrifice to make. (For
users of legacy systems, we could point them to the (unmaintained)
driver on SF.)

> if you have 2 or more boards, could you check if
> my driver is working with more than one board?

Sorry, I only have 1 board available to test with.

Marin, if you are considering upgrading your driver, I propose
we send an email to the DT3155 SF mailing list & ask for help
testing. (I already know of 1 other person who is happy to help
test.) I recommend making userspace programs (like examples/acquire
& examples/Xview in the SF driver) available first. Ideally, these
example programs & user space libraries would become the major
component of the evolved DT3155 SF project.

What do you think?

Scott. :)
