Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbZL0VC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbZL0VC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZL0VC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:02:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60677 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZL0VC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:02:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [2.6.33-rc1 regression] suspend doesn't work on X200s
Date: Sun, 27 Dec 2009 22:02:50 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <cb0375e10912211645w1fecfafcj8f1c0ab9ce23b077@mail.gmail.com>
In-Reply-To: <cb0375e10912211645w1fecfafcj8f1c0ab9ce23b077@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912272202.50897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 December 2009, Andrew Lutomirski wrote:
> Hi all-
> 
> On Linus's tree from yesterday (2.6.33-rc1 plus a bit, I think) with
> drm-next patched in, I can't suspend.  My sleep light starts blinking
> (userspace does that, I think) and the screen goes blank, then the
> caps lock and num lock lights blink once (this is supposed to happen
> when suspending), and then the system freezes hard with the fan and
> backlight still on and the suspend light still blinking.
> 
> I'm pretty sure this has nothing to do with drm changes, since I can
> suspend fine on 2.6.32.1 with include/drm and drivers/drm copied from
> the broken 2.6.33-rc1 + drm-next tree.

I've created a Bugzilla entry for your report at
http://bugzilla.kernel.org/show_bug.cgi?id=14887

Please put your hardware information in there.

Rafael
