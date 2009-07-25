Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZGYTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZGYTKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZGYTKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 15:10:43 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:40068 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZGYTKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 15:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sOV3PqvkgJPicjheVGWmjoc9l1r6QoE0ibBwK7EeLMmcMZ63xMJbH4WiEmBbIgIXRo
         G7lYRnKH9YWSCj++48rzuafdJf7zACW+HdxyMjHrf/YSLSaMbI+jgX7cUZHirLeXszcS
         ZnJnJkknqsfpecDarVF2CKVgSBD0Ep5LclSEM=
Date: Sat, 25 Jul 2009 12:10:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Message-ID: <20090725191037.GE14062@dtor-d630.eng.vmware.com>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com> <20090725174449.GC14062@dtor-d630.eng.vmware.com> <200907252019.01266.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907252019.01266.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 08:18:58PM +0200, Frans Pop wrote:
> On Saturday 25 July 2009, Dmitry Torokhov wrote:
> > On Wed, Jul 22, 2009 at 05:18:39PM +0200, Manuel Lauss wrote:
> > > Cc: Frans Pop <elendil@planet.nl>
> > > Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
> > >
> > > +
> > > +static struct dev_pm_ops au1xmmc_pmops = {
> > > +	.resume		= au1xmmc_resume,
> > > +	.suspend	= au1xmmc_suspend,
> > > +};
> > > +
> >
> > Was suspend to disk tested? It requires freeze()/thaw().
> 
> Is that a regression introduced by this patch then? If so, many more of 
> the recent dev_pm_ops conversion patches would need to be revisited.

Yes, as far as I understand they would. Let's ask Rafael to confirm...

-- 
Dmitry
