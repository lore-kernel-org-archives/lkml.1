Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYCQUTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYCQUTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbYCQUS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:18:56 -0400
Received: from hansmi.home.forkbomb.ch ([213.144.146.165]:7411 "EHLO
	hansmi.home.forkbomb.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbYCQUS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:18:56 -0400
Date: Mon, 17 Mar 2008 21:18:52 +0100
From: Michael Hanselmann <linux-kernel@hansmi.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, michel@tungstengraphics.com
Subject: Re: [PATCH] Update key codes for Apple aluminium keyboards
Message-ID: <20080317201852.GA30667@hansmi.ch>
References: <20080317161826.GA29601@hansmi.ch> <Pine.LNX.4.64.0803171759390.30831@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0803171759390.30831@jikos.suse.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 06:00:18PM +0100, Jiri Kosina wrote:
> On Mon, 17 Mar 2008, Michael Hanselmann wrote:
> > After a discussion with the autor of the original patch adding support
> > for Apple's new aluminium keyboards
> > (a45d82d19a6c2a717bcc33cff243199b77fa0082), Michel Dänzer, we decided
> > that some changes should be done.

> Could you please describe the changes in more detailed way, explaining why 
> are they needed, so that we have it in changelog properly? Thanks.

Sure:

---
F5 and F6 have no second function printed on them. Thus their
definitions have been removed from the table.

KEY_CYCLEWINDOWS doesn't name the function of Mac OS X' Exposé properly
and because we couldn't find a better key code, we decided to use
KEY_FN_F4 instead.

We also changed KEY_BACK and KEY_FORWARD, which apply to browser
functions, to KEY_PREVIOUSSONG and KEY_NEXTSONG, since the keys are
intended to control a music player.
---

Does this contain enough details?

Thanks,
Michael
