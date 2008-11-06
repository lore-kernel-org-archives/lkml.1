Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYKFUrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYKFUrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYKFUqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:46:53 -0500
Received: from mail.crca.org.au ([67.207.131.56]:59323 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYKFUqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:46:52 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
	hotplug
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0811060947250.2456-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0811060947250.2456-100000@iolanthe.rowland.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 07 Nov 2008 07:46:46 +1100
Message-Id: <1226004406.6876.5.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2008-11-06 at 09:48 -0500, Alan Stern wrote:
> On Thu, 6 Nov 2008, Nigel Cunningham wrote:
> 
> > Remember that when we hibernate (assuming we don't then suspend to ram),
> > the power is fully off. Resuming starts off like a fresh boot.
> 
> That simply is not true.  On ACPI systems, hibernation goes into the S4 
> state.  Power fully off is S5.

For the purposes of our discussion, it was a good enough description.
Nevertheless, you're right - if we do everything in a fully ACPI spec
compliant way, there will still be some power around. Of course we don't
always do that (can use S4 or S5).

Regards,

Nigel

