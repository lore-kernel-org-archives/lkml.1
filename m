Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbXB1S2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbXB1S2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXB1S2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:28:24 -0500
Received: from styx.suse.cz ([82.119.242.94]:44336 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932227AbXB1S2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:28:22 -0500
Date: Wed, 28 Feb 2007 19:29:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702281013190.12485@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702281922110.4255@jikos.suse.cz>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281837200.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702281013190.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Linus Torvalds wrote:

> > But OK, I will leave it in there.
> No. You need to realize just WHY it was wrong. Not just an "But OK".

Yep, I totally agree that with the usbhid.h thing I really had a bad day, 
it was braindamage without excuse, sorry.

I still think that creating a separate header file solely for purpose of 
having the large hid blacklist and all related defines separate from the 
actual implementation is needed. The pages and pages of blacklist just 
pollute the hid-core.c needlessly. 

Of course hid-core.c must be the only user of this header. But seems like 
this solution oposes your taste ("The point of a header file is to 
*declare* things, not to have big data structures in"), so I would 
probably not go this way.

Thanks,

-- 
Jiri Kosina
