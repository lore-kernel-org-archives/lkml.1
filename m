Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXERNOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXERNOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXERNOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:14:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:12800 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbXERNO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P9j6V1/AGGlC3q7h4UX6IMfZb4gEePKl/25X5WepiPjTKX1i24iEjZVsxG68wYEyyoUBVf79nB64Fpxk0IgAf01TqTrgNsDcIi85OzW10TkJXgL3LID1Cr8UvfbqTAKhflqxON4f9pxmlxPO1YRDRuMLhD5MgT8eBsbcDtbpBg0=
Message-ID: <a781481a0705180614u72556b39pf4d0afd00c8c0ce5@mail.gmail.com>
Date: Fri, 18 May 2007 18:44:26 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org
In-Reply-To: <20070518112437.GQ10562@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517172023.GL10562@parisc-linux.org>
	 <20070517182414.GA12170@infradead.org>
	 <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
	 <20070517185115.GA13207@infradead.org>
	 <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com>
	 <20070517193953.GM10562@parisc-linux.org>
	 <20070517194326.GC30571@kvack.org>
	 <20070517213043.GN10562@parisc-linux.org>
	 <a781481a0705172228j34e0b3eblade96458163475cb@mail.gmail.com>
	 <20070518112437.GQ10562@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, May 18, 2007 at 10:58:05AM +0530, Satyam Sharma wrote:
> > [ BTW, this is the last time I'll try explaining this to you. ]
>
> Oh good.  Perhaps you can just drop the idea entirely and give up?

Well, I do plan to, at least as far as convincing you or getting some
alternative in mainline is concerned.

> > The one-line patch you're suggesting *would*not*allow* one to use the async
> > scanning _at_all_. If one really wants to use async scanning reliably (even
> > in
> > the future, as it can be turned on at boot-time later, like you very well
> > know),
> > that module *must* be built. Making it user-visible and/or optional would
> > *not*
> > be a solution but a *problem*. What I have been suggesting is *not* to make
> > this *dummy module* user-visible and/or optional but to _not_ use this
> > *dummy module* for this purpose in the first place.
>
> That's simply not true.  There are other ways of using async scanning
> reliably -- as Peter Jones pointed out.  If you're relying on the earlier
> semantics of "modprobe returned, therefore scanning is complete", then
> yes, it's unreliable.  But if you're using kevents/udev/etc to find out
> when devices have been discovered, then it's not unreliable.

But I do hope the mainline kernel does want to give (by default) the best
way/interface of doing this for users/distros, at least. From Peter's mail,
I gather that we can do better than what we are presently doing.

> > [ This time, I don't see the subject changing, nor a "change in the general
> > direction of the thread blah blah blah", and still you feel compelled to not
> > maintain the CC list. Wow. ]
>
> I see trimming the CC list as a courtesy to those who've had enough of
> this pointless thread landing in their mailboxes.

Well you trimmed out those original "three users" who did show interest in
this in the first place. Anyway, pointless it indeed has become...
