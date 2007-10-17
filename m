Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbXJQJs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbXJQJs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbXJQJsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:48:47 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:60905 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbXJQJsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:48:45 -0400
Date: Wed, 17 Oct 2007 11:48:39 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071017094838.GB18035@boogie.lpds.sztaki.hu>
References: <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm> <20071016195432.GA31306@parisc-linux.org> <Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 01:55:07PM -0700, david@lang.hm wrote:

> why is this any different from the external enclosures? they have always 
> appeared as the type of device that connects them to the motherboard, (and 
> even with SCSI, there are some controllers that don't generate sdX devices)

In the past enclosures supported only one kind of connector so this
assumption was fine. But nowadays an external disk may have several
connectors (like USB, Firewire and eSata). Why should the disk's name
depend on what type of cable did I manage to grab first? It is the
_same_ disk regardless of the cable type.

There is one thing however that could be improved: renaming a disk in an
udev rule should propagate the new name back to the kernel, just like
renaming an ethernet interface does. That way mapping error messages to
physical disk locations could be made much easier.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
