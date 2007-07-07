Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbXGGCtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbXGGCtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXGGCtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:49:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:52336 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbXGGCtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:49:01 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org
In-Reply-To: <200707061153.05091.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
	 <1183712354.3388.126.camel@localhost.localdomain>
	 <200707061131.08475.oliver@neukum.org>  <200707061153.05091.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 12:46:37 +1000
Message-Id: <1183776397.3388.203.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 11:53 +0200, Rafael J. Wysocki wrote:
> 
> Moreover, I claim that, in the context of your example, _if_ the task
> is stuck
> at the wait_event_uninterruptible(), _then_ the freezerless suspend
> will
> deadlock with the task.

Why would the task be stuck there if it's not becasue of a freezer ? The
only reason I see would be a dependency on something like kmalloc trying
to push things to disk, or a lock owned by another user process, but the
former is a generic issue I've discussed in a separate mail and the
later is a driver bug imho.

Ben.


