Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYI3CaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYI3CaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYI3CaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:30:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:26072 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYI3CaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:30:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="445116428"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Linux 2.6.27-rc8
Date: Mon, 29 Sep 2008 19:30:05 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52064B1CE4@orsmsx418.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux 2.6.27-rc8
Thread-Index: Ackin7vPWxmFhpOwScGQ/SW0ucrTQwAAkRrQ
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz> <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jiri Kosina" <jkosina@suse.cz>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Sep 2008 02:30:06.0136 (UTC) FILETIME=[734FCB80:01C922A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> What's the magic to trigger it? I've got a laptop with that e1000e
> chip in it, and am obviously running a recent kernel on it. Do people
> have a handle on it? Is it actually verified to be kernel-related,
> and not related to the X server etc?

my current status mail was posted earlier today to lkml from this
address, since then we've had a local reproduction and are going for
number two.  The reproduction seems racy, i.e. it doesn't happen every
time, so we put it in a loop doing detect, check eeprom, detect, etc,
and we'll see if it fails.

Reproduction seems to consistently be around X probing time, no firm
leads yet.  As for Intel we have keithp and jbarnes as well as arjan,
auke, myself and a few others involved.

We have some patches to lock the nvm down, we'll be posting those
tonight and tomorrow, I also have some debug logic (and fixes) to help
prove that we don't think it's a race in e1000e.
--
Jesse
