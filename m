Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0CCVtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:49:36 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:43900 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab0CCVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:49:30 -0500
Date: Wed, 03 Mar 2010 16:49:01 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend][PATCH] ACPI / EC: Remove race between EC driver and
 suspend process (rev. 3)
In-reply-to: <201002272140.36891.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.1003031644410.1044@localhost.localdomain>
References: <201002272140.36891.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the record, Rafael, Alexey and I discusseed this a bit further...

We reasoned that this failure is impossible during the Suspend-to-RAM 
path, and the failure is specific to the hibernate reboot kernel handoff
to the resume image.

On a related note, we had trouble justifying the existence
of the current EC .suspend and .resume routines.

thanks,
Len Brown, Intel Open Source Technology Center

