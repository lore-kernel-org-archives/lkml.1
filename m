Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYKFOnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYKFOnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKFOnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:43:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57517 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751132AbYKFOnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:43:41 -0500
Date: Thu, 6 Nov 2008 09:43:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Tolentino <matthew.e.tolentino@intel.com>, Hansen <haveblue@us.ibm.com>,
       <linux-pm@lists.osdl.org>, <Matt@smtp1.linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
       <Dave@smtp1.linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       <Andy@smtp1.linux-foundation.org>, Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
In-Reply-To: <20081106091441.6517c072.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.44L0.0811060941200.2456-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, KAMEZAWA Hiroyuki wrote:

> Am I missing some ? Current linux can know PCI/USB hotplug while the
> system is suspended ?

With some machines, yes, it can.  Some computers provide minimal 
"suspend current" to devices while the system is hibernating.  This 
allows the hardware to detect and remember hotplug events, which can 
then be handled when the system wakes up.

Alan Stern

