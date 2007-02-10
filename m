Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXBJCWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXBJCWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 21:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXBJCWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 21:22:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:13903 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXBJCWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 21:22:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=E9pGHqZ46DbhpGYh2Cc29deYCmvRAIszqutlOq8K0ruzX3J3mRH+91eIYjHGJorfEeyTzxNetK3IdKmM2AmikW/ioEzEzZiJUD8ilGcaL2EPNRymWiYCF/G2CWOe9GvXc9teQ0TyIpANYodq93kOAXmSJ5c4SBblKXuKYVvRPb8=
Message-ID: <75b66ecd0702091822n19cf88b8k63bbd705cf5367ae@mail.gmail.com>
Date: Fri, 9 Feb 2007 21:22:48 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Cc: "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <1171073398.3863.9.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	 <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no>
	 <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no> <45CD24F6.8090107@shaw.ca>
	 <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com>
	 <1171073398.3863.9.camel@nigel.suspend2.net>
X-Google-Sender-Auth: ffda6432627f1e88
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> On Fri, 2007-02-09 at 20:59 -0500, Lee Revell wrote:
> > On 2/9/07, Robert Hancock <hancockr@shaw.ca> wrote:
> > > I would disagree that it's a peripheral issue, it's pretty core these
> > > days, at least for any hardware that you can stuff in a laptop (though a
> > > fair number of desktops get suspended and resumed these days too).
> >
> > Servers are still the most important Linux market, and don't care
> > about suspend/resume.  I would consider implementing suspend./resume
> > for a driver that will only be used in server or HPC class hardware a
> > waste of valuable development resources.
>
> Not necessarily. Imagine suspending to disk in order to replace a faulty
> card. That could be way faster and less disruptive than shutting down
> normally and loosing caches and so on.
>

Hmm.  If uptime is critical I would make sure to have redundant
systems anyway and I would just reboot the thing.  I would not expect
the suspend/resume paths on server class hardware like 10gig ethernet,
Infiniband adapters, or high end SCSI to be particularly well tested.

> Irrespective of the above, servers tend not to have too much in the way
> of hardware unique to them anyway, and even if you don't find it useful,
> that's not to say others won't want it.

Yes but for such hardware, suspend/resume is likely to be a lot of
work to implement, and I'd rather the developers devote those
resources to making the driver as stable and performant as possible.

I agree 100% that drivers for desktop and laptop hardware should be
rejected if missing suspend/resume.

Lee
