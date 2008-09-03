Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYICV2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYICV2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYICV2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:28:35 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52122 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbYICV2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:28:34 -0400
X-Sasl-enc: mBgb3TGM6MORDTwVdV5ivIQcexue5QAiK1fjbLAwWQGR 1220477311
Date: Wed, 3 Sep 2008 18:28:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Steven King <sfking@fdwdc.com>, Tomas Carnecky <tom@dbservice.com>,
       Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume
	after?undocking
Message-ID: <20080903212827.GB14620@khazad-dum.debian.net>
References: <200808301535.22419.sfking@fdwdc.com> <20080901112816.GA21970@khazad-dum.debian.net> <48BBDD2C.5020804@dbservice.com> <200809011205.05253.sfking@fdwdc.com> <20080903144541.GA10978@homac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903144541.GA10978@homac>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Holger dropped from CC/To as requested by the mail-followup-to header).

On Wed, 03 Sep 2008, Holger Macht wrote:
> On Mon 01. Sep - 12:05:04, Steven King wrote:
> > On Monday 01 September 2008 5:16:44 Tomas Carnecky wrote:
> > 
> > > I just tested suspend/resume with the CDROM drive removed (an empty
> > > bay). Suspend/resume now works just fine, regardless how I dock/undock
> > > the laptop.
> > 
> > I'm seeing the exact same things as Tom.  Also, in my dmesg I see:
> > 
> > ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
> > ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
> > ACPI: Error installing bay notify handler
> > 
> > is this significant?
> 
> No, it's not. Bay driver is obsolete with 2.6.26's libata hotplug code.

Hardly so.  We need to be able to query state and command the bay from
userspace.  We need to support non-libata devices.  We don't need, but want,
notifications that can be easily flagged by userspace as being related to
bay/dock ejections and insertions (for OSD).

What makes bay obsolete is the rework on the dock driver that adds all bay
functionality to dock.c... and that ain't even on 2.6.27, AFAIK.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
