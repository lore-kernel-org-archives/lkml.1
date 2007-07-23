Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbXGWNOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbXGWNOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXGWNO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:14:29 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40824 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbXGWNO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:14:28 -0400
To: oliver@neukum.org
CC: miklos@szeredi.hu, rjw@sisk.pl, nigel@nigel.suspend2.net,
       stern@rowland.harvard.edu, nigel@suspend2.net, jbms@cmu.edu,
       miltonm@bga.com, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       david@lang.hm, linux-pm@lists.linux-foundation.org
In-reply-to: <200707231431.30372.oliver@neukum.org> (message from Oliver
	Neukum on Mon, 23 Jul 2007 14:31:29 +0200)
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707231408.32051.rjw@sisk.pl> <E1ICwoE-0004q8-00@dorka.pomaz.szeredi.hu> <200707231431.30372.oliver@neukum.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1ICxdo-0004w2-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jul 2007 15:08:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The reason is that we want them to "park" in safe places, ie. where there
> > > are no locks held etc.  Thus, these safe places need to be chosen somehow
> > > and since they are not marked throughout the code, we choose the obvious
> > > one. :-)
> > 
> > Why shouldn't locks be held?
> > 
> > No locks which are required for suspend must be held, sure.  But
> > otherwise holding locks doesn't matter at all.
> 
> If you can provide a way to tell them apart, this would work.

Without some marking we can't tell obviously.

Are there many such locks?  We can easily check by adding some
debugging code to the lock primitives, to make them yell if they are
used during suspend.

Miklos
