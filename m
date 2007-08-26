Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbXHZWe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbXHZWe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 18:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXHZWeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 18:34:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbXHZWet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 18:34:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: Suspend corrupts bios clock since 2.6.21
Date: Mon, 27 Aug 2007 00:45:08 +0200
User-Agent: KMail/1.9.5
Cc: Andreas Steffan <a.steffan@deas-online.de>,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz,
       linux-kernel@vger.kernel.org
References: <fa.Hms7k1HwOwCbv7cPqUWGLhT5uyk@ifi.uio.no> <46D1D6D1.5040203@shaw.ca>
In-Reply-To: <46D1D6D1.5040203@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708270045.09050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 August 2007 21:38, Robert Hancock wrote:
> Andreas Steffan wrote:
> > Hallo everybody,
> > 
> > I am running fedora core 7 on my Dell latitude D810 notebook (BIOS
> > rev A05).
> > 
> > Since 2.6.21 I found that suspending (to disk and to ram) corrupts
> > the bios clock most of the time (not always). The corruption is
> > happening during suspend. When I enter the system bios right after
> > I switch the system back on, I find the bios clock is set to a time
> > far in the future (many years). I guess that problem is related to
> > the clock changes that where introduced with 2.6.21.
> > 
> > Please let me know if you want me to provide further information to
> > get this problem fixed.
> > 
> > If there is a known quirk to work around this problem, I would
> > really appreciate a hint.
> > 
> > PS: I have not yet tried 2.6.22.4-65.fc7, but the latest 2.6.22 kernel
> > before showed the same behaviour for me.
> 
> Please check if PM_TRACE is enabled in your kernel configuration. It 
> will do this intentionally.

Yes, but only if you have "1" in /sys/power/pm_trace ...

Greetings,
Rafael
