Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYCMR42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYCMR42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYCMR4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:56:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:31789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbYCMR4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BM5OA+oQ1zXp6/7GIS+o8rT88FybwlCFeaGO7PuJz+uSHZbewKCwR2+Qu3p2eOHugQDv/k+ZF/j8KDyfjNIbDIMHxyUFVJxwGCq1nWZwIa2LyZr5Ps4i4l4eYBNjypWRkP8vsSiXJgiAtWkUOjIkV8YoxJ9x1I3IX7Y4tdydaXQ=
Message-ID: <f188924b0803131056m2aae7625x24bd00136b712076@mail.gmail.com>
Date: Thu, 13 Mar 2008 18:56:04 +0100
From: "Fred ." <eldmannen@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: Keys get stuck
Cc: "David Newall" <davidn@davidnewall.com>, "Jiri Kosina" <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080313171425.GA4840@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
	 <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz>
	 <47D7B428.6010804@davidnewall.com> <20080313171425.GA4840@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With so many people suffering from this bug (for a long time), and so
many bright people here, why doesn't it get fixed?

...other operating systems don't suffer from this bug...

On Thu, Mar 13, 2008 at 6:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
> On Wed 2008-03-12 21:14:56, David Newall wrote:
>  > Jiri Kosina wrote:
>  > > Very probably this is due to broken way how X themselves implement
>  > > auto-repeat, instead of using kernel-provided auto-repeat functionality.
>  >
>  > It should be said that X implements auto-repeat out of necessity.  While
>  > the kernel can report key down and up events, its further interpretation
>  > of those events is not appropriate.  Many combinations of events are
>  > possible, such as keyboard plus mouse, and this precludes the kernel
>  > from providing a full interpretation.  It would be wrong for it to even
>  > try.  X is the proper place to implement auto-repeat for X.
>
>  No.
>
>  hw is proper place to implement autorepeat, and along with some
>  buffering, it has chance to work. Kernel is not real-time, and X are
>  definitely not real-time, while autorepeat is real-time operation.
>
>  It actually mostly works in ps/2 case. Buffer in hardware means that
>  pretty big interrupt delays can be tolerated without problems.
>
>  --
>  (english) http://www.livejournal.com/~pavelmachek
>  (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
