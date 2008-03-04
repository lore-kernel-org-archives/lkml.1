Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbYCDS0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbYCDS0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932218AbYCDSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:25:45 -0500
Received: from outbound-mail-122.bluehost.com ([67.222.38.22]:47453 "HELO
	outbound-mail-122.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932206AbYCDSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:25:44 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 13:25:43 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Date: Tue, 4 Mar 2008 10:18:28 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de>
In-Reply-To: <20080304054927.GA15566@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041018.29035.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 03, 2008 9:49 pm Greg KH wrote:
> On Sat, Mar 01, 2008 at 07:43:07AM -0700, Matthew Wilcox wrote:
> > On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
> > > What is the guarantee that the names of these slots are correct and do
> > > not happen to be the same as the hotpluggable ones?
> >
> > That would be a bug -- and yes, bugs happen, and we have to deal with
> > them.
>
> My main concern is that BIOS vendors will not fix these bugs, as no
> other OS cares/does this kind of thing today.  The ammount of bad
> information out there might be quite large, and I think this was
> confirmed by some initial testing of IBM systems, right?

Yeah, but there's a flip side to this too:  if no one uses the data, no one 
will complain when it's wrong.  If Linux starts making it easy to see this 
stuff, there's a chance system vendors will start taking an extra 5 min. 
before shipment to make sure that the BIOS info is up to date...

OTOH, I'm not sure which is worse, bad data or no data.

Jesse
