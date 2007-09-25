Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbXIYUln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbXIYUln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXIYUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:41:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:7474 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbXIYUlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hot/fWDKJ3IHeL+hxQWnuy/dlFq6h2B9VJx2Aer7pq+duFrwtWjEMftRIc5jP8odISdx2s+EreASTe3nAVz3qH8KSOEhYhE3OrGHdhihDcd0U8eNZNmxRIWhcvb3IdAaUfYa1N+2U9UWVWpwN8cVoP6KbFvMF1dvoAD0BjvRb9I=
Message-ID: <d120d5000709251341s222c8560wdf46c5a3c9b36ada@mail.gmail.com>
Date: Tue, 25 Sep 2007 16:41:30 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Michael Guntsche" <mike@it-loops.com>
Subject: Re: 2.6.23 /proc/bus/input/devices content question
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <B5B5C841-6068-413B-A765-73A34E988FAA@it-loops.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6D36DFB9-B26D-4CEA-B7AD-0216F7124FC5@it-loops.com>
	 <d120d5000709251051n45e415e6gbdd87a98f0b8cdd4@mail.gmail.com>
	 <B5B5C841-6068-413B-A765-73A34E988FAA@it-loops.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Michael Guntsche <mike@it-loops.com> wrote:
>
> On Sep 25, 2007, at 19:51, Dmitry Torokhov wrote:
>
> > Hi Michael,
> >
> >> ...
> >> I this a "wanted" change or should I still see the same with 2.6.23?
> >>
> >
> > Is this with CONFIG_SYSFS_DEPRECATED=y?
>
> No, CONFIG_SYSFS_DEPRECATED is not set with both kernels.

Ok, this is expected. Input devices were converted form class devices
into standard devices. Unless SYSFS_DEPRECTAED is set to Y sysfs
changes are expected.

-- 
Dmitry
