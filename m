Return-Path: <linux-kernel-owner+w=401wt.eu-S1761015AbYDNOvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015AbYDNOvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYDNOvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:51:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33037 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751720AbYDNOvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:51:35 -0400
Date: Mon, 14 Apr 2008 10:51:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: benh@kernel.crashing.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 8)
In-Reply-To: <200804132147.03579.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0804141049370.2236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008, David Brownell wrote:

> I sort of agree.  Looking at it from a whole-system perspective,
> suspending needs to be able to chitchat with userspace ... and I
> don't think that can be done *before* writing to /sys/power/state
> in an acceptably generic/portable way.  (Briefly, applications
> need to have clean stopping points and be able to arrange system
> wakeup.  They may well have more work to do than most drivers.)

Pavel's recent work aside, the only way to initiate a system sleep is 
from userspace.  So it seems natural for all application notifications 
to be made by the initiating program, perhaps via dbus.

Alan Stern

