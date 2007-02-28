Return-Path: <linux-kernel-owner+w=401wt.eu-S933302AbXB1RlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbXB1RlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933299AbXB1RkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:40:25 -0500
Received: from styx.suse.cz ([82.119.242.94]:43393 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933294AbXB1RkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:40:22 -0500
Date: Wed, 28 Feb 2007 18:41:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702281837200.4255@jikos.suse.cz>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Linus Torvalds wrote:

> There is no excuse for putting a large array in a header file and 
> including it millions of times. Or even just twice. The point of a 
> header file is to *declare* things, not to have big data structures in.

The point was that noone else than hid/hid-core.c would ever be going to 
include this header with blacklist. The blacklist is growing in time quite 
rapidly and having it in the middle of the code just didn't look pretty - 
currently you have to perform some scrolling effort just to skip from 
usbhid_init_reports() to hid_find_max_report(), which just looks very sad 
to me.

But OK, I will leave it in there.

-- 
Jiri Kosina
