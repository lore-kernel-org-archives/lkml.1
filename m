Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYAKChk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYAKChk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYAKChc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:37:32 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:28996 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033AbYAKCha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RWeCkMjTd0YWNkZ+1arsjPrXsqYEaXRHwDNhwXsMjImBGr/X8jNgiYdPmQncWZiiEcjd7HBj+Bzmwt3PYBO4NMQ6ILK5rKZPopt/KE6vxVvwG+wk/uHhwHwAvPQfoym2F19efJAyC6EoFGBF41mb23H67IQcmqaVDdgcL4hfv68=
Message-ID: <a8e1da0801101837n54e1de5bs8b39c2b79ff10640@mail.gmail.com>
Date: Fri, 11 Jan 2008 10:37:29 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Cc: "Greg KH" <gregkh@suse.de>, "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       James.Bottomley@hansenpartnership.com,
       "SCSI development list" <linux-scsi@vger.kernel.org>,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>, krh@redhat.com,
       rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
In-Reply-To: <Pine.LNX.4.44L0.0801101038580.4267-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	 <Pine.LNX.4.44L0.0801101038580.4267-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 11:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 10 Jan 2008, Dave Young wrote:
>
> > Hi,
> > The patches are done on my side, please help to check.
> >
> > This is the first one of the series about driver core changes.
> > If this one is accepted and there's no other problem I will post the others for maintainer's review (they need your comment and help because I don't know well about the specific driver logic).
>
> Before spending too much time on all these conversions, shouldn't you
> first determine whether they will work with the lockdep checker?  In
> one of your earlier messages there was a clear indication that they
> will not.
Thanks.

I managed to build and boot ok with lockdep config options except the
apm_power which need to be cross compiled.

But not sure whether there's something which are not hit yet.
>
> Alan Stern
>
>
