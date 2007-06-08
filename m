Return-Path: <linux-kernel-owner+w=401wt.eu-S1030682AbXFHQgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682AbXFHQgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969445AbXFHQgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:36:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969333AbXFHQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:36:36 -0400
Subject: Re: 2.6.22-rc4-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Jones <pjones@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070608155139.GB7833@suse.de>
References: <1181206091.3625.9.camel@lov.localdomain>
	 <4667D2DF.30207@googlemail.com> <1181228660.3625.23.camel@lov.localdomain>
	 <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de>
	 <20070607085200.f8d6e2d3.akpm@linux-foundation.org>
	 <20070607155953.GA17591@suse.de>
	 <20070607090632.cfcf02e6.akpm@linux-foundation.org>
	 <20070607161525.GA18363@suse.de>
	 <20070608003118.b8334635.akpm@linux-foundation.org>
	 <20070608155139.GB7833@suse.de>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 18:36:25 +0200
Message-Id: <1181320585.3625.92.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/gabbb9sVXHBUnBEcli6XJOpgVzPAEkGX2SXM
 d6qqpUiIZhmVPr/vsMszI2V8hvjPe2pyXuri7ZaweMY6TbRjy4
 UoGutV94tpe8YpLXzeVlnc8Q5aF1mBG
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 08:51 -0700, Greg KH wrote:
> On Fri, Jun 08, 2007 at 12:31:18AM -0700, Andrew Morton wrote:
> > On Thu, 7 Jun 2007 09:15:25 -0700 Greg KH <gregkh@suse.de> wrote:
> > 
> > > On Thu, Jun 07, 2007 at 09:06:32AM -0700, Andrew Morton wrote:
> > > > On Thu, 7 Jun 2007 08:59:53 -0700 Greg KH <gregkh@suse.de> wrote:
> > > > 
> > > > > On Thu, Jun 07, 2007 at 08:52:00AM -0700, Andrew Morton wrote:
> > > > > > On Thu, 7 Jun 2007 08:43:42 -0700 Greg KH <gregkh@suse.de> wrote:
> > > > > > 
> > > > > > > >  Fixed in mkinitrd-6.0.9-6 , which I'll build now and push to 
> > > > > > > >  updates-testing.  Thanks for getting my attention here.
> > > > > > > 
> > > > > > > Great, Andrew, can you please reenable the block-device patch that is in
> > > > > > > my tree now that the problem has been solved?
> > > > > > 
> > > > > > I think we're screwed, aren't we?  Everyone needs to upgrade mkinitrd to be
> > > > > > able to boot the kernel?  Not viable :(
> > > > > > 
> > > > > > For example, what about my two-year-old yellowdog machine?
> > > > > 
> > > > > Enable CONFIG_SYSFS_DEPRECATED and it should all work just fine.  That's
> > > > > what Michal said worked for him.
> > > > > 
> > > > 
> > > > Actually, it _was_ enabled.
> > > > 
> > > > Ho hum, I'll have a poke at it this evening.
> > > 
> > > Yeah, that sounds odd, it should have worked.
> > 
> > yup, yellowdog 4.1 on a mac g5:
> > 
> > gregkh-driver-block-device.patch applied, CONFIG_SYSFS_DEPRECATED=y:
> > 	http://userweb.kernel.org/~akpm/s5000552.jpg
> 
> Ugh.
> 
> Kay, any thoughts?  Does switchroot need to have the --movedev option
> removed for some reason?

Hmm, no idea, /sys/block should not have changed with
CONFIG_SYSFS_DEPRECATED=y. And it works fine for Michal and FC7.

Alan Stern mentioned the --movedev option with its customized initramfs,
or did other people report something similar?

Peter, any idea what it could be, that goes wrong on Andrew's box, or
how to look for what exactly is going wrong?
  http://userweb.kernel.org/~akpm/s5000552.jpg
Seems that yellowdog uses RH's nash.

Thanks,
Kay

