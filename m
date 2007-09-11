Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXIKOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXIKOlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXIKOlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:41:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbXIKOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:41:07 -0400
Date: Tue, 11 Sep 2007 07:39:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Nigel Cunningham <ncunningham@crca.org.au>, nigel@suspend2.net,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix failure to resume from initrds.
In-Reply-To: <200709111523.33968.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.999.0709110736440.16478@woody.linux-foundation.org>
References: <200709111354.25689.nigel@nigel.suspend2.net> <200709111355.07369.rjw@sisk.pl>
 <200709111512.35348.rjw@sisk.pl> <200709111523.33968.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Sep 2007, Rafael J. Wysocki wrote:
> > Anyway, yes, init is freezable, but should it be?
> > 
> > I mean, shouldn't we rather add PF_NOFREEZE to kernel_init()?
> 
> Argh, no.  PF_NOFREEZE is inherited by the children.

Umm. All of this is __init code - why is freezability even an issue? We 
shouldn't be suspending at this point anyway afaik..

Is suspend2 perhaps doing something different here? 

		Linus
