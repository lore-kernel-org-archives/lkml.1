Return-Path: <linux-kernel-owner+w=401wt.eu-S1763872AbXLTWa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763872AbXLTWa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXLTWaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:30:17 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58168 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbXLTWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:30:16 -0500
Date: Thu, 20 Dec 2007 14:29:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Message-Id: <20071220142952.ff562b22.randy.dunlap@oracle.com>
In-Reply-To: <20071220221252.GA16431@kroah.com>
References: <20071220003031.GA15129@kroah.com>
	<20071219223206.ada18362.randy.dunlap@oracle.com>
	<20071220212700.GB5808@kroah.com>
	<20071220140659.71f6cce6.randy.dunlap@oracle.com>
	<20071220221252.GA16431@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 14:12:52 -0800 Greg KH wrote:

> On Thu, Dec 20, 2007 at 02:06:59PM -0800, Randy Dunlap wrote:
> > On Thu, 20 Dec 2007 13:27:00 -0800 Greg KH wrote:
> > > On Wed, Dec 19, 2007 at 10:32:06PM -0800, Randy Dunlap wrote:
> > > > On Wed, 19 Dec 2007 16:30:31 -0800 Greg KH wrote:
> > > > >     int kobject_uevent(struct kobject *kobj, enum kobject_action action);
> > > > > 
> > > > > Use the KOBJ_ADD action for when the kobject is first added to the kernel.
> > > > > This should be done only after any attributes or children of the kobject
> > > > > have been initialized properly, as userspace will instantly start to look
> > > > 
> > > > 		s/will/may/
> > > 
> > > No, it's usually a "will", as udev is damm fast these days :)
> > 
> > But that's the point.  It assumes that udev is being used.  :(
> 
> Yes, kernel developers need to be aware that udev _will_ be used, you
> can not do things that will assume it is not running.

so are you saying that udev is required now?
I missed that information somehow/somewhere.

---
~Randy
