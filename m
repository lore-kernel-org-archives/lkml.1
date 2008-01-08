Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYAHXGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYAHXGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYAHXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:06:26 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:36175 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbYAHXGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:06:24 -0500
Date: Wed, 9 Jan 2008 00:06:00 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108230600.GA9071@citd.de>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Don't use udev then. Good old static dev works fine if you have a fixed
> > set of devices.
> 
> It doesn't, with the unpredictable SCSI mapping insanity.

That what LABEL und UUID-Support in mount is for.

You label the filesystems (e2label for ext2 and ext3) and use that label to mount them

- fstab -
LABEL=root  /        xfs     defaults,noatime	0 1
LABEL=boot  /boot    ext2    defaults,noatime	0 2
...
- snip -





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

