Return-Path: <linux-kernel-owner+w=401wt.eu-S933611AbZHHD5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbZHHD5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 23:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933292AbZHHD5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 23:57:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbZHHD5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 23:57:41 -0400
Date: Fri, 7 Aug 2009 20:48:17 -0700
From: Greg KH <gregkh@suse.de>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, OpenIB <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ofa-general] IB kernel modules and the kobject release()
 method
Message-ID: <20090808034817.GA30697@suse.de>
References: <e2e108260908060943u344bbe03k2baab01b204c9cca@mail.gmail.com>
 <adad478hmi8.fsf@cisco.com>
 <e2e108260908061146y47ae45f5j6b8085d44cd1c45b@mail.gmail.com>
 <adaocqsg339.fsf@cisco.com>
 <e2e108260908061229v2c605aabp7cf66cbe568d6755@mail.gmail.com>
 <adafxc4g1e7.fsf@cisco.com>
 <e2e108260908070026s10658adl2c4a9a5b3eba1a08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2e108260908070026s10658adl2c4a9a5b3eba1a08@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:26:33AM +0200, Bart Van Assche wrote:
> On Thu, Aug 6, 2009 at 9:58 PM, Roland Dreier<rdreier@cisco.com> wrote:
> >
> >  > Are you sure that this indicates a shortcoming in the kobject
> >  > debugging code ? The most recent messages related to the message "does
> >  > not have a release() function, it is broken and must be fixed" I could
> >  > find on the LKML date from July 16, 2009
> >  > (http://lkml.org/lkml/2009/7/16/306 and
> >  > http://lkml.org/lkml/2009/7/16/391). As you can see Greg KH
> >  > acknowledges that if this message is logged that this indicates a
> >  > problem that should be fixed.
> >
> > I'm not sure -- I just assume that the core module unloading code is
> > working OK, since it is so heavily tested.  If there were really a "must
> > be fixed" problem with module unloading then someone would surely have
> > hit more than a warning message.
> 
> (added Greg KH and the LKML in CC)
> 
> I tried to look up more information about kobjects. The comment of
> commit 7a6a41615bfb2f03ce797bc24104c50b42c935e5 suggests that in the
> past the function kobject_cleanup() did not free the memory allocated
> for static kobject names but that this was the responsibility of the
> release() function. This should have been fixed in the current version
> of kobject_cleanup(). So I'm wondering whether the message that
> kobjects that do not have a release() function are broken still makes
> sense ?

No, it still makes sense :)

thanks,

greg k-h
