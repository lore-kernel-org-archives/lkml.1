Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZA3PLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZA3PLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZA3PLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:11:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56129 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZA3PLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:11:25 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd generation iPods
Date: Fri, 30 Jan 2009 10:16:04 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@bitplanet.net>
References: <Pine.LNX.4.44L0.0901291536020.2394-100000@iolanthe.rowland.org> <49821F99.4070108@s5r6.in-berlin.de>
In-Reply-To: <49821F99.4070108@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301016.05012.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 16:28:57 Stefan Richter wrote:
> Alan Stern wrote:
> > On Thu, 29 Jan 2009, Stefan Richter wrote:
> >> Obviously they changed something in Ubuntu 8.10 which suddenly made 3rd
> >> gen iPods vulnerable too.  If the report is accurate, then this is /not/
> >> the READ CAPACITY 10 issue where device's capacity report is off by one.
> >> (The reported capacity without workaround is an even number and thus
> >> possibly correct.)
> > 
> > Don't make that assumption.  One of the small number of devices which 
> > really did have an odd number of sectors was an early iPod.
> 
> Ah, interesting.
> 
> (Jarod, didn't you see OS X report the same size on that 3rd gen. iPod
> as Linux without quirk flag, or did I dream this?  In any case this
> could of course simply mean that OS X uses a wrongly reported size...)

I don't think I looked at the 3rd-gen iPod's reported size under OS X,
the place I saw OS X size matching Linux size sans-quirk-flag was with
a 20GB 4th-gen iPod. I can certainly check the 3rd-gen too though.


-- 
Jarod Wilson
jarod@redhat.com
