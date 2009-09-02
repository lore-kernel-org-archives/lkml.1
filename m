Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbZIBLbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbZIBLbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZIBLbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbZIBLbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:31:41 -0400
Date: Wed, 2 Sep 2009 08:31:24 -0300
From: Glauber Costa <glommer@redhat.com>
To: Chris Lalancette <clalance@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 2/2] add sysctl for kvm wallclock sync
Message-ID: <20090902113124.GK30340@mothafucka.localdomain>
References: <1251805848-17451-1-git-send-email-glommer@redhat.com> <1251805848-17451-2-git-send-email-glommer@redhat.com> <1251805848-17451-3-git-send-email-glommer@redhat.com> <4A9E16AD.8080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9E16AD.8080508@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 08:54:37AM +0200, Chris Lalancette wrote:
> Glauber Costa wrote:
> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> > index fc409e9..3a4e1bd 100644
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -27,7 +27,7 @@
> >  #define KVM_SCALE 22
> >  
> >  static int kvmclock = 1;
> > -static unsigned int kvm_wall_update_interval = 5;
> > +unsigned int kvm_wall_update_interval = 5;
> 
> I think the overall idea is very interesting, but I also think that it should be
> disabled by default.  Because of the problems with time in virtualization,
> people are already conditioned to run ntpd inside their guests, and this
> kvmclock change will "fight" with ntpd.  Also, the command "# date 09091323" (or
> whatever) ceases to work like it does on bare-metal, so I think it has to be an
> opt-in feature.
I don't disagree.

Actually, I thought about that myself a few hours after I sent the patch. 
Avi, do you have a word on that ?
