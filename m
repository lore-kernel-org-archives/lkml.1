Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbXEKOVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbXEKOVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbXEKOVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:21:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:3760 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761423AbXEKOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=haK4wTYLx8RrYKt7oqgIHDgkibzpcOxsaqoUfVr3M4cNXR0kdb9UyzSeqkGhTcMSt7oI+ozm1LOH8x2grxifE3edsBjgw/fzyolH6JrUQoX7tTZBFpVt0Ib0yWlyoUbuW7JUYVuuLocVcwJ/kG8LpYLsSPa0Cxul2FijMS11S8Y=
Message-ID: <a781481a0705110721h68a10969nacd0a7c6d9b423ee@mail.gmail.com>
Date: Fri, 11 May 2007 19:51:21 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [PATCH] "volatile considered harmful", take 2
Cc: "jimmy bahuleyan" <knight.camelot@gmail.com>,
       "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20070511122113.GB15972@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6143.1178828419@lwn.net> <464382DE.5020206@gmail.com>
	 <20070511122113.GB15972@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Fri, May 11, 2007 at 02:08:54AM +0530, jimmy bahuleyan wrote:
> > Jonathan Corbet wrote:
> > [snip..]
> > > +
> > > +  - The jiffies variable is special in that it can have a different value
> > > +    every time it is referenced, but it can be read without any special
> > > +    locking.  So jiffies can be volatile, but the addition of other
> > > +    variables of this type is strongly frowned upon.  Jiffies is considered
> > > +    to be a "stupid legacy" issue in this regard.
> >
> > Why is it that you consider jiffies to be a "stupid legacy"? Isn't it
> > natural to have a externally modified variable which is only /read/ to
> > be volatile? (or is jiffies supposed to be replaced with something
> > smarter/better :)
>
> "stupid legacy" were Linus' words. http://lwn.net/Articles/233482/
>
> How about this:
>
> "The jiffies variable is a special case because there are too
> many places in the kernel which would have to be changed and reviewed
> if the volatile would be removed from jiffies. However, the
> use of volatile qualifier for jiffies is just as wrong as
> it is elsewhere. Don't use jiffies as an excuse to use volatile
> in your code."

Yes, or some "good" combination of the original and this one :-)

The problem with natural languages is that one is never quite satisfied
(or convinced) that one has expressed all that one wished to express,
and as nicely as one wanted to. That's often not the case with programming
languages, by contrast.
