Return-Path: <linux-kernel-owner+w=401wt.eu-S1750942AbXA3S4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbXA3S4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXA3S4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:56:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:44849 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXA3S4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:56:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aYW4LALeNJDUThu1MQf3ck+OsfGUOob9x8qUveheUzOWYDswR9LI4aIUUrB8lCfL1SIvDd7ALAl2RtpmRSJms1gxY17zP/bp6kYzEW/2M9iF0Y549hvMxyQCRZAvxemOsMpX3u6YpfiTMZ6+QfdyE/VHujg2IRjAsbc0moU/2n0=
Message-ID: <671c20540701301056l6ff1d876xb8df0d9d83ea2c8a@mail.gmail.com>
Date: Tue, 30 Jan 2007 13:56:48 -0500
From: "Tom Burns" <tom.i.burns@gmail.com>
To: "Tim Schmielau" <tim@physik3.uni-rostock.de>
Subject: Re: Bug: 2.6.15 Process accounting fails to account for small time slice loads (still)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0701301840470.14441@gockel.physik3.uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
	 <Pine.LNX.4.63.0701301840470.14441@gockel.physik3.uni-rostock.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim.

That would be great if you could find that patch - I can worry about
porting it to the current kernel.  We're having an issue where our
device, while routing large amounts of network traffic, reports 0% CPU
utilisation when it cannot be the case, and I think this is the cause.

Cheers,
Tom Burns

On 1/30/07, Tim Schmielau <tim@physik3.uni-rostock.de> wrote:
> On Tue, 30 Jan 2007, Tom Burns wrote:
>
> > The bug described back in 2004 in the following message still seems to exist:
> >
> > http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-05/4313.html
> >
> > Essentially, it appears that if a process sleeps before it uses up a
> > complete jiffy then no charge is made to its process accounting table.
>
> That's not a bug, it's a feature. ;-)
>
> More seriously, it's a design decision. The benefit of exactly correct
> micro bookkeeping does not seem to warrant the extra cost in terms of cpu
> cycles spent in the accounting code.
>
> IIRC there was a patch for that some years ago, if you are interested I
> will try to find it. No idea how much work it would be to port it to
> current kernels, though.
>
> Tim
>
