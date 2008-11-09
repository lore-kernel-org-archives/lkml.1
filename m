Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYKITym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYKITym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYKITye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:54:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbYKITyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:54:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Mathieu Chouquet-Stringer" <mchouque@free.fr>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Date: Sun, 9 Nov 2008 20:59:30 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20081109195033.GA1335@mobydick>
In-Reply-To: <20081109195033.GA1335@mobydick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811092059.31178.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of November 2008, Mathieu Chouquet-Stringer wrote:
> 	Hello Pavel and Rafael,
> 
> I've just finished compiling a recent snapshot of rc3 (namely gfed4d59
> [1]) on a F9 distro (gcc 4.3.0 20080428) and suspend to disk doesn't
> work anymore.  My config is attached below [2].
> 
> It just freezes my laptop (an old Thinkpad T30) while it works with
> kernel version 2.6.26 (I've never tried 2.6.27).
> 
> I've tried playing with the pm_test facility, and while the "freezer"
> test works, the "devices" test fails like the real suspend...
> 
> When that happens, the console still works (ie I can switch VTs and
> type) but the whole system doesn't respond: I can't login for example...
> Guess the disk driver is already off at that point.
> 
> I don't have another computer to capture a serial trace so I guess I'm
> going to try to bisect it (which is going to take while on this slow
> computer).  If I reconfigure my syslog could I get the output of the
> suspend process on the screen (for some reason I used to get it during
> suspend but now I only get it during resume)?
> 
> Any ideas or pointers to fix this appreciated...

Please check if that's http://bugzilla.kernel.org/show_bug.cgi?id=11989 and
if that's the case, please add a "me too" to the bug entry.

Thanks,
Rafael
