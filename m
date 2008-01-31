Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYAaB3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYAaB3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYAaB3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:29:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:21925 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbYAaB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:29:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NceBgv0EPso+M9k9NvB9DC5kbTyp8n4LL6DzqhhmL4/pDCUrnbgIq6FZ6R9Xv8n2I7ORK2semySSfLQaqz2VAhLnIEer3aoTq2VYvqHPEVdI9u3H4OCynpHWF00UwY4tjgRIKbQAh7aMERBPYBlLhwY87F0uQpWyZvvGPcKjwco=
Message-ID: <a8e1da0801301729j5b3084e0nffb29a740870a793@mail.gmail.com>
Date: Thu, 31 Jan 2008 09:29:05 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH retry] bluetooth : add conn add/del workqueues to avoid connection fail
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <1201688462.6218.47.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080130022354.GA3132@darkstar.te-china.tietoenator.com>
	 <20080129.211446.254604070.davem@davemloft.net>
	 <1201688462.6218.47.camel@violet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 6:21 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
> > > The bluetooth hci_conn sysfs add/del executed in the default workqueue.
> > > If the del_conn is executed after the new add_conn with same target,
> > > add_conn will failed with warning of "same kobject name".
> > >
> > > Here add btaddconn & btdelconn workqueues,
> > > flush the btdelconn workqueue in the add_conn function to avoid the issue.
> > >
> > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
> > This looks good, applied, thanks Dave.
> >
> > I've queued this up for 2.6.25 merging, if you want me to
> > schedule it for -stable, just let me know.
>
> don't include it. I first have to stress test it on one of my machines.
> Besides that I have to do some coding style cleanups.

Sorry, I thought you forgot it.
Thanks.

BTW, for the bus_id bug, If there's no urgent need I think we could do
the fix after driver core bus_id changes of kay which will be there
soon.

>
> Regards
>
> Marcel
>
>
>
