Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZCDV7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZCDV7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZCDV7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:59:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56877 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752902AbZCDV7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:59:33 -0500
Date: Wed, 4 Mar 2009 16:59:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>, Yinghai Lu <yinghai@kernel.org>,
       Sarah Sharp <sarah.a.sharp@intel.com>, <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: EHCI debug documentation
In-Reply-To: <m1bpshx912.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0903041657140.6145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Eric W. Biederman wrote:

> Greg KH <gregkh@suse.de> writes:
> 
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> Yinghai Lu wrote:
> >> > b. netchip USB debug cable
> >> 
> >> http://www.plxtech.com/products/NET2000/NET20DC/default.asp
> >
> > I have reports that the newer version of this device does not work on
> > Linux as it isn't enumeratable as a "real" usb device on one end.
> >
> > I don't have one of these new devices yet to test it out, has anyone
> > else heard of this problem?
> 
> With the first generation of devices I remember they were peculiar and
> finicky.  I don't recall the exact details but I remember the devices
> able to get into weird states that may resemble what you describe.

Those devices were a little peculiar in that they were powered only on
one side.  That is, they would take bus power only from the right-hand
connector (looking at the face with the PLX logo).  So if you plugged
in only the left side, the device would not show up or enumerate.  But 
if you plugged in both sides, then both of them would enumerate okay.

Alan Stern

