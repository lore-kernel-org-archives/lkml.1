Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbXG2JsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbXG2JsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760993AbXG2JsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:48:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760992AbXG2JsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:48:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Hibernation considerations
Date: Sun, 29 Jul 2007 11:56:36 +0200
User-Agent: KMail/1.9.5
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
References: <200707151433.34625.rjw@sisk.pl> <200707160038.12943.rjw@sisk.pl> <20070729065352.GB17084@suse.cz>
In-Reply-To: <20070729065352.GB17084@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291156.38046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 08:53, Vojtech Pavlik wrote:
> On Mon, Jul 16, 2007 at 12:38:11AM +0200, Rafael J. Wysocki wrote:
> 
> > > Or the user unplugs their flash drive after hibernation rather than before.
> > > 
> > > Two things which I think would be nice to consider are:
> > >    1) Encryption - I'd actually prefer if my luks device did not
> > >        remember the key accross a hibernation; I want to be forced to
> > >        reenter the phrase.  However I don't know what the best thing
> > >        to do to partitions/applications using the luks device is.
> > 
> > Encryption is possible with both the userland hibernation (aka uswsusp) and
> > TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a "must
> > have" feature for a framework to be generally useful (many users don't use it
> > anyway).
> 
> If a user uses an encrypted filesystem, then he also needs an encrypted
> swap and encrypted hibernation image: Otherwise the fileystem encryption
> is not very useful.

I was talking about hibernation image encryption.  Arguably, if the image is
encrypted, you don't need to worry about its contents, including the keys for
other kinds of encryption (eg. fs encryption).
 
> Forgetting the filesystem/swap decryption keys before hibernation is
> probably harder to do - there may be sensitive data in the kernel memory
> image that weren't cleared - even if the key itself is not there.

If the image is encrypted, its contents are not available to anyone
unauthorized and that includes the filesystem/swap decryption keys.

> In my opinion, encrypted hibernation is what every notebook user should
> want - that's the only way how to make sure data from the notebook
> aren't available when the notebook is physically stolen.

Provided that there are any sensitive (to the user or her employer etc.) data
in the notebook.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
