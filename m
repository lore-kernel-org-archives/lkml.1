Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbXG2GyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbXG2GyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 02:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759711AbXG2GyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 02:54:13 -0400
Received: from styx.suse.cz ([82.119.242.94]:33210 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759709AbXG2GyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 02:54:12 -0400
Date: Sun, 29 Jul 2007 08:53:52 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
Message-ID: <20070729065352.GB17084@suse.cz>
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey> <200707160038.12943.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707160038.12943.rjw@sisk.pl>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 12:38:11AM +0200, Rafael J. Wysocki wrote:

> > Or the user unplugs their flash drive after hibernation rather than before.
> > 
> > Two things which I think would be nice to consider are:
> >    1) Encryption - I'd actually prefer if my luks device did not
> >        remember the key accross a hibernation; I want to be forced to
> >        reenter the phrase.  However I don't know what the best thing
> >        to do to partitions/applications using the luks device is.
> 
> Encryption is possible with both the userland hibernation (aka uswsusp) and
> TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a "must
> have" feature for a framework to be generally useful (many users don't use it
> anyway).

If a user uses an encrypted filesystem, then he also needs an encrypted
swap and encrypted hibernation image: Otherwise the fileystem encryption
is not very useful.

Forgetting the filesystem/swap decryption keys before hibernation is
probably harder to do - there may be sensitive data in the kernel memory
image that weren't cleared - even if the key itself is not there.

In my opinion, encrypted hibernation is what every notebook user should
want - that's the only way how to make sure data from the notebook
aren't available when the notebook is physically stolen.

-- 
Vojtech Pavlik
Director SuSE Labs
