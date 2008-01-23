Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYAWBDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYAWBDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYAWBCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:02:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:9638 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYAWBCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UwS7DQ3lbAgdqmHJPrijb2IiaZiOB3LQmqd4HVJ9l0NAHi9L3kNCFhVfzI9sG8zjFt/O73QCnE8c7cydAoNUIKUsHUqu8ztjSst+lnJ/3PjEHf6ow3WBH1ZealcaenImhjcg6OqnvBZZkywCRdilQn9FGAqiJqYfdHYe44T58ng=
Message-ID: <a8e1da0801221702l7ea912baj548c6f40c7680f6e@mail.gmail.com>
Date: Wed, 23 Jan 2008 09:02:53 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 1/6] driver-core : add class iteration api
Cc: "David Brownell" <david-b@pacbell.net>, "Greg KH" <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
       dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com,
       cornelia.huck@de.ibm.com
In-Reply-To: <20080122222550.GB7146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	 <20080122055434.GB3066@darkstar.te-china.tietoenator.com>
	 <200801212224.18149.david-b@pacbell.net>
	 <20080122072708.GB3725@darkstar.te-china.tietoenator.com>
	 <20080122222550.GB7146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23, 2008 6:25 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 22, 2008 at 03:27:08PM +0800, Dave Young wrote:
> >
> > Add the following class iteration functions for driver use:
> > class_for_each_device
> > class_find_device
> > class_for_each_child
> > class_find_child
>
> As class_for_each_child() is not used by anyone in this patch series,
> and we want to heavily discourage the use of class_device (only scsi and
> IB are the last remaining users), I'll cut out this portion of the
> patch.
>
> Any objection?

Looks good to me.

>
> thanks,
>
> greg k-h
>
