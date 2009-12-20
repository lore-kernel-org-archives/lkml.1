Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZLTMv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZLTMv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZLTMvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:51:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36859 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbZLTMvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:51:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 13:52:07 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912192253200.6618-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912192253200.6618-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912201352.07689.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Alan Stern wrote:
> On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> 
> > So, seriously, do you think it makes sense to do asynchronous suspend at all?
> > I'm asking, because we're likely to get into troubles like this during suspend
> > for other kinds of devices too and without resolving them we won't get any
> > significant speedup from asynchronous suspend.
> > 
> > That said, to me it's definitely worth doing asynchronous resume with the
> > "start asynch threads upfront" modification, as the results of the tests show
> > that quite clearly.  I hope you agree.
> 
> It's too early to come to this sort of conclusion (i.e., that suspend
> and resume react very differently to an asynchronous approach).  Unless
> you have some definite _reason_ for thinking that resume will benefit
> more than suspend, you shouldn't try to generalize so much from tests
> on only two systems.

In fact I have one reason.  Namely, the things that drivers do on suspend and
resume are evidently quite different and on these two systems I was able to
test they apparently took different amounts of time to complete.

The very fact that on both systems resume is substantially longer than suspend,
even if all devices are suspended and resumed synchronously, is quite
interesting.

Rafael
