Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXB0Klg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXB0Klg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932996AbXB0Klg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:41:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:41365 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbXB0Klf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f2AwYBtjPT3hQVg1xvSuZ9yO74mjgfo3rqGcJl5rXtHJ8UQWgE0nBu7TKwPL3elwfKB1QR6IHsiOUIHxnFsociPvQJGrbJn7+AYzufyXBOKhPMCmF77Awe0JqRV4FlfDAIN4rfr/q3cfuAQXsZFfSHaxCIjS5caegQJsC+YByNs=
Message-ID: <abe01d5c0702270241s75f70301y6e1cddacf65e8829@mail.gmail.com>
Date: Tue, 27 Feb 2007 07:41:30 -0300
From: "Fausto Carvalho" <faustocarva@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Using serio_register_driver
In-Reply-To: <200702270034.09603.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <abe01d5c0702261503p3212d7dcg925588bb325a4460@mail.gmail.com>
	 <abe01d5c0702261732k6634ff02u69e07562a39b9a8d@mail.gmail.com>
	 <200702270034.09603.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, i have a 8042 controller "connected" to the keyboard controller
that send information about battery and others to the keyboard
interrupt and io ports in the format of keystrokes. I want a way to
not alter atkbd but to create another driver that lives together with
atkbd. Is there a way?


On 2/27/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> On Monday 26 February 2007 20:32, Fausto Carvalho wrote:
> > Can you help me??
> >
> > ---------- Forwarded message ----------
> > From: Fausto Carvalho <faustocarva@gmail.com>
> > Date: Feb 26, 2007 8:03 PM
> > Subject: Using serio_register_driver
> > To: linux-kernel@vger.kernel.org
> >
> >
> > I have a driver that have to coexist with ATKBD accessing the same
> > i8042 platform driver. But when a use serio_register_driver and
> > program the serio_driver.interrupt i only get the atkbd to respond!!
> > Is there any way to use ATKBD with another i8042 driver( serio)??
> > Any help is wellcome.
> >
>
> Hi,
>
> Unfortunately you can't attach more than one driver to a serio port.
> Could you tell me what you are trying to achive in your driver?
>
> --
> Dmitry
>


-- 
Fausto Carvalho
