Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbXFGGmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbXFGGmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXFGGl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:41:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:42105 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXFGGl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a3BGsoY3Iet/R85Al81dsBHBkm769fYpQkHC6CYJAS1mjSpVNd4lGuTq7Tt05CSBA8z2nu1MtGDB3UZbdQHy9C7PFcWwhQCp/hDGlo7tTZLSd92c67eJUcYqLGJwY3N7XZVastrtPAZoVvgSSGhXNzCmeKc46viNI8iU4AMzKiw=
Message-ID: <a781481a0706062314v7696ca06p47e279e626403529@mail.gmail.com>
Date: Thu, 7 Jun 2007 11:44:02 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [linux-usb-devel] [PATCH] bug removing ehci-hcd
Cc: Stuart_Hayes@dell.com, akpm@linux-foundation.org, malattia@linux.it,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <a781481a0706062252oa09dcf7xc6a190d2479e837a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070529093324.92e571a0.akpm@linux-foundation.org>
	 <DFEF91B22ED07447AB6AA4B237F913F9524D64@ausx3mpc125.aus.amer.dell.com>
	 <20070607041924.GA8545@kroah.com>
	 <a781481a0706062252oa09dcf7xc6a190d2479e837a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi,
>
> I remember this one ...
>
> On 6/7/07, Greg KH <greg@kroah.com> wrote:
> > On Thu, May 31, 2007 at 10:26:10AM -0500, Stuart_Hayes@Dell.com wrote:
> > >
> > > I wasn't actually able to reproduce the bug myself, but I guess it is
> > > pretty obvious that I shouldn't have called cpufreq_unregister_notifier
> > > with a spinlock held.  I haven't been doing this long enough to know
> > > exactly which kernel this patch should be against, so let me know if
> > > this ins't good.  Thanks!
> > >
> > >
> > > This patch (for the 2.6.21.3 kernel plus previously sent cpufreq
> > > notifier patch) fixes a bug caused by calling
> > > cpufreq_unregister_notifier (which can sleep) while holding a spinlock.
> > >
> > > Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
> >
> > Hm, this doesn't apply to the 2.6.21.3 kernel.
>
> The cpufreq patches only live in -mm as of now ...

Argh, excuse the noise!

> > Can you send both patches merged together?
> >
> > And is the fix already in Linus's tree?

And you clearly meant gregkh-usb-usb-ehci-cpufreq-fix.patch
here ... (btw, no, I don't see this in the latest git)

Satyam
