Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYARBp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYARBp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYARBpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:45:50 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:28016 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYARBpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YeVG/1LJyqYqvksEq8Bvg7aTJJCX4qgG2rMRK3WStr9+B+Vy3ySb/VpG8ekNhXmXalOrrPx+Yd/0aGn8i7cLIfE+T094LXc+7W+qZ4SS+kxCGbP/LMupKo+T0bwYzLTLonfIWyQ+O4r9mH6tzYNmF4DYCe2MhstL9BYkz923Y/E=
Message-ID: <a8e1da0801171745m3f0aa92bjfdf0a2f1e379ad50@mail.gmail.com>
Date: Fri, 18 Jan 2008 09:45:48 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Jarek Poplawski" <jarkao2@gmail.com>, "Greg KH" <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0801171014030.4378-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0801161718w573ac941jc83011e63c47ecf@mail.gmail.com>
	 <Pine.LNX.4.44L0.0801171014030.4378-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 11:16 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 17 Jan 2008, Dave Young wrote:
>
> > > Your meaning isn't clear.  Do you mean that your patch doesn't generate
> > > any lockdep warnings at all?  Or do you mean that it generates a single
> > > lockdep warning at boot time and then no more warnings afterward?
> >
> > I means the latter one.
>
> That's very bad.
>
> For each type of violation, lockdep only gives one error message.  So
> the fact that you get one message at boot time and then no more doesn't
> mean the code is almost right -- it probably means the code has lots of
> errors and you're seeing only the first one.

You are right, I should have check all possible one.

>
> Alan Stern
>
>
