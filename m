Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbYCUQqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbYCUQqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756575AbYCUQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:45:59 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5350 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbYCUQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:45:58 -0400
Date: Fri, 21 Mar 2008 10:45:56 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH  1/16][BUG] Export kobject_rename for pci_hotplug_core
	(Not for mainline!)
Message-ID: <20080321164556.GH17292@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <gregkh@suse.de>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E334E2.6060306@jp.fujitsu.com> <20080321155605.GE17292@ldl.fc.hp.com> <20080321161532.GA2349@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321161532.GA2349@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Fri, Mar 21, 2008 at 09:56:05AM -0600, Alex Chiang wrote:
> > Hi Greg,
> > 
> > This patch looks like a candidate for the current 2.6.25 cycle.
> > Any chance of getting it in there?
> 
> Is this a problem today?  I don't see it being one, so when you need
> this function exported, we can do it then.  Otherwise people will just
> start sending me patches unexporting it as they don't see any in-kernel
> users of it :)
> 
> So just keep it as part of your patchset, it's easier for everyone that
> way.

Ok, sounds fair to me.

> And it will remind me to verify that you really should be calling
> kobject_rename and not just getting the name correctly the first time
> around...{hint}

I'm pretty sure we really do need to call it, but I appreciate
your future review. ;)

/ac

