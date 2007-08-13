Return-Path: <linux-kernel-owner+w=401wt.eu-S938941AbXHMCat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938941AbXHMCat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 22:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934795AbXHMCal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 22:30:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:34573 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531AbXHMCak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 22:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XEo/mPKJkNwNFy7j3bJc0WNnFQJRElZltznjTh+zLM3MmMTuxVvPKNaQ3gzq4jVY761Xb525p/0iAZdARdl253iUe3Z2SghvBvbeqy3863SUmDnRZBNd5rRoIoRpnn+347lZ7nSzqnQz9jmof72IFVzNt2/e59yPUuWRK3oDspk=
Message-ID: <b14e81f00708121930n7d9eab99r6fa776120c6287c1@mail.gmail.com>
Date: Sun, 12 Aug 2007 22:30:39 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: encrypted hibernation (was Re: Hibernation considerations)
Cc: "Pavel Machek" <pavel@ucw.cz>, "Vojtech Pavlik" <vojtech@suse.cz>,
       seife@suse.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "pm list" <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       "Al Boldi" <a1426z@gawab.com>
In-Reply-To: <20070811234356.GA19183@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey>
	 <200707160038.12943.rjw@sisk.pl> <20070729065352.GB17084@suse.cz>
	 <20070805195628.GA1947@elf.ucw.cz> <20070811234356.GA19183@gallifrey>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/07, Dr. David Alan Gilbert <linux@treblig.org> wrote:
> * Pavel Machek (pavel@ucw.cz) wrote:
> > Hi!
> >
> > > > > Two things which I think would be nice to consider are:
> > > > >    1) Encryption - I'd actually prefer if my luks device did not
> > > > >        remember the key accross a hibernation; I want to be forced to
> > > > >        reenter the phrase.  However I don't know what the best thing
> > > > >        to do to partitions/applications using the luks device is.
> > > >
> > > > Encryption is possible with both the userland hibernation (aka uswsusp) and
> > > > TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a "must
> > > > have" feature for a framework to be generally useful (many users don't use it
> > > > anyway).
> > >
> > > If a user uses an encrypted filesystem, then he also needs an encrypted
> > > swap and encrypted hibernation image: Otherwise the fileystem encryption
> > > is not very useful.
> >
> > Actually, we can do most of that stuff already.
> >
> > We can encrypt filesystems, encrypt swaps (LVM), and encrypt hibernation.
>
> But can you do what my original question was; find a way to lose a luks
> encrypted device key and cleanly unmount the filesystem that was
> using it?  (and preferably put it all back together after resume).
>

If you lose the device key, how are you going to get luks to find it
again when resuming? Wouldn't it make more sense to have it remember
the key? I can't see it being advisable to allow input or similar
before resume has completed...

-- 
Michael Chang

Please avoid sending me Word or PowerPoint attachments. Send me ODT,
RTF, or HTML instead.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
