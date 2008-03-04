Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbYCDUCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbYCDUCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYCDUCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:02:42 -0500
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:60433 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753962AbYCDUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:02:41 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Date: Tue, 4 Mar 2008 12:02:09 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de>
In-Reply-To: <20080304193036.GB5534@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041202.09702.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 04, 2008 11:30 am Greg KH wrote:
> bad data is worse.

But we don't want to throw the baby out with the bathwater; assuming there are 
lots of machines out there with good data (I really hope that's the case), 
this feature seems like a really good idea.

> And then there's the machines with duplicate slot names, how does this
> code handle PCI slots with that?  I think some of the IBM machines had
> non-hotplug slots named the same as the hotplug slots, right?
>
> This stuff needs a _lot_ of testing on a lot of different machines, and
> a sane way to fall-back if there are errors to ensure that working
> machines don't break.

Yeah, I think a good fallback is important.  Might be good to have a blacklist 
along with a heuristic for detecting duplicate slot names...  Anyway, yeah, 
testing will be huge here.

Jesse
