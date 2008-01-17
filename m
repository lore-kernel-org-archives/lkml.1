Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYAPX5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYAPX5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYAPX5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:57:35 -0500
Received: from hu-out-0506.google.com ([72.14.214.231]:42080 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYAPX5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:57:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JRbfGjpfCKtCGdecWF+9zMYwjnnLRKA7jzYQUPCG+06mo7CZsPYueslpwvYIqC0oeKvK+gYkwRTra6fagpLGOnGBd7kYGJugMaIDp/bZDH++ExrDkzjQLPkOgqekOc6xv6BA+eFJLvMZrZnw97J0peH/DDDlv9L1FFRhX+7OWIQ=
Date: Thu, 17 Jan 2008 01:01:21 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080117000121.GB2626@ami.dom.local>
References: <a8e1da0801151703w52df227en42eae85e75d5017f@mail.gmail.com> <Pine.LNX.4.44L0.0801161026090.4431-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801161026090.4431-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 10:27:54AM -0500, Alan Stern wrote:
> On Wed, 16 Jan 2008, Dave Young wrote:
> 
> > The lockdep warining was posted in the below thread, actually, I have
> > built and run this patced kernel for several days, there's no more
> > warnings.
> > http://lkml.org/lkml/2008/1/3/2
> 
> Your meaning isn't clear.  Do you mean that your patch doesn't generate
> any lockdep warnings at all?  Or do you mean that it generates a single
> lockdep warning at boot time and then no more warnings afterward?

So it wasn't only my sleeping problem! This:

"One lockdep warning detected as following, thus use mutex_lock_nested
 with SINGLE_DEPTH_NESTING in class_device_add"

seems to say that mutex_lock_nested is used in the patch just to remove
this one possible warning...

Regards,
Jarek P.
