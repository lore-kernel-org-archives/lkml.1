Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbXGWOHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbXGWOHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXGWOH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:07:29 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:53953 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbXGWOH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:07:28 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, stern@rowland.harvard.edu, oliver@neukum.org,
       nigel@nigel.suspend2.net, nigel@suspend2.net, jbms@cmu.edu,
       miltonm@bga.com, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       david@lang.hm, linux-pm@lists.linux-foundation.org
In-reply-to: <200707231601.09541.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707231431.30372.oliver@neukum.org> <E1ICxdo-0004w2-00@dorka.pomaz.szeredi.hu> <200707231601.09541.rjw@sisk.pl>
Message-Id: <E1ICyTB-00056Q-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jul 2007 16:01:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan has recently proposed to introduce "suspend locks" to be acquired during
> a suspend/hibernation and such that we can leave uninterruptible tasks that
> don't hold any of them.

Sounds sane.  A global rwsem could be acquired for read by drivers,
and for write by suspend/hibernate.  Just need to add it to all
drivers that have PM, but that shouldn't need a heroic effort.

Miklos
