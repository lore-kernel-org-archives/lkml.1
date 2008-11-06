Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYKFOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYKFOsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYKFOsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:48:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40366 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750842AbYKFOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:48:23 -0500
Date: Thu, 6 Nov 2008 09:48:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>,
       <linux-pm@lists.osdl.org>, Dave Hansen <haveblue@us.ibm.com>,
       <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
       <linux-mm@kvack.org>, <pavel@suse.cz>, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
In-Reply-To: <1225936818.6216.20.camel@nigel-laptop>
Message-ID: <Pine.LNX.4.44L0.0811060947250.2456-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Nigel Cunningham wrote:

> Remember that when we hibernate (assuming we don't then suspend to ram),
> the power is fully off. Resuming starts off like a fresh boot.

That simply is not true.  On ACPI systems, hibernation goes into the S4 
state.  Power fully off is S5.

Alan Stern

