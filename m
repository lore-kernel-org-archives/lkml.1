Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXENHQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXENHQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbXENHQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:16:31 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:32609 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124AbXENHQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cFwV/akwF5Et6o8f5K8z5/RxBdNIXPgMpDKq7eoqmtMNSDgp5kKgSFLIqlZpZSF6hx1/hjZGXfxxdOHCNHT/vHLFeaGEaOk0QceUrynmJce0uxBrB1faYpXQlMFMcxFwHaQ2AvwAnYOo4mwTez5C5l77QBzhhLP7PseUqUNXN7k=
Message-ID: <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
Date: Mon, 14 May 2007 12:46:26 +0530
From: "Learning Linux" <learninglinux4@gmail.com>
To: "pradeep singh" <2500.pradeep@gmail.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: kernelnewbies@nl.linux.org, linux-newbie@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have a very basic doubt here ... what makes it impossible to sleep
> > in an ISR? I mean, I know that the kernel preemption is disabled and
> > the kernel will panic, but I could not understand why?
>
> Because the interrupt which you are serving in the
> ISR has been masked to avoid preemption(
> true for maskable inetrrupts ).Any locks you are holding in ISR are now with
> you solely. So, if you try to sleep you take the locks you untill you are
> rescheduled and complete. This may lead to
> a deadlock for the lock resource.

Ok, but how about an ISR, that does not take any locks? Why can't we
sleep in SUCH an ISR?

AFAIK, taking a lock disables kernel preemption, and hence it is not
allowed to sleep. So I think my question would boil down to why is
sleeping not allowed when the kernel preemption is disabled.

LL
