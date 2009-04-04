Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZDDWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZDDWKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 18:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZDDWK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 18:10:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZDDWKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 18:10:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [RFC][PATCH] PM: Warn if interrupts are enabled during suspend-resume of sysdevs
Date: Sun, 5 Apr 2009 00:10:26 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: lenb@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200904042323.19866.rjw@sisk.pl> <200904050003.33609.elendil@planet.nl>
In-Reply-To: <200904050003.33609.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904050010.26855.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009, Frans Pop wrote:
> > @@ -377,6 +381,9 @@ int sysdev_suspend(pm_message_t state)
> >         if (ret)
> >                 return ret;
> >  
> > +       WARN_ONCE(!irqs_disabled(),
> > +               "Interrupts enabled while suspending system devices");
> > +
> 
> Missing \n ?
> 
> > @@ -452,6 +465,9 @@ int sysdev_resume(void)
> >  {
> >         struct sysdev_class *cls;
> >  
> > +       WARN_ONCE(!irqs_disabled(),
> > +               "Interrupts enabled while resuming system devices");
> > +
> 
> Again.

Yes, thank.

Rafael
