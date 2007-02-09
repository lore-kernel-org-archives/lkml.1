Return-Path: <linux-kernel-owner+w=401wt.eu-S1423357AbXBIWpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423357AbXBIWpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423355AbXBIWpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:45:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423357AbXBIWps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:45:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Fri, 9 Feb 2007 23:44:14 +0100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, pm list <linux-pm@lists.osdl.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <1171059968.1484.90.camel@nigel.suspend2.net>
In-Reply-To: <1171059968.1484.90.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702092344.14984.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 9 February 2007 23:26, Nigel Cunningham wrote:
> Hi.
> 
> On Fri, 2007-02-09 at 23:17 +0100, Arjan van de Ven wrote:
> > On Sat, 2007-02-10 at 08:57 +1100, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > I don't think this is already done (feel free to correct me if I'm
> > > wrong)..
> > > 
> > > Can we start to NAK new drivers that don't have proper power management
> > > implemented? There really is no excuse for writing a new driver and not
> > > putting .suspend and .resume methods in anymore, is there?
> > 
> > 
> > to a large degree, a device driver that doesn't suspend is better than
> > no device driver at all, right?
> 
> I'm not sure it is. It only makes more work for everyone else: We have
> to help people figure out what causes their computer to fail to resume
> (which can take quite a while), then get them them complain to driver
> author, and the driver author has to submit patches to fix it.
> 
> All of this is avoided if they'll just do it right in the first place.
> 
> > now.. if you want to make the core warn about it, that's very fair
> 
> That's probably a good idea too, since I'm only suggesting this for new
> drivers.

I think if CONFIG_PM_DEBUG is set, the core should warn about drivers not
having .suspend or .resume routines.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
