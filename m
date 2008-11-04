Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYKDAxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYKDAxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 19:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYKDAw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 19:52:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54200 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYKDAw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 19:52:57 -0500
Subject: Re: [PATCH] hibernation should work ok with memory hotplug
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, linux-pm@lists.osdl.org,
       Matt Tolentino <matthew.e.tolentino@intel.com>,
       Dave Hansen <haveblue@us.ibm.com>, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <200811040129.35335.rjw@sisk.pl>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <200811040005.12418.rjw@sisk.pl> <1225753819.12673.518.camel@nimitz>
	 <200811040129.35335.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 16:52:47 -0800
Message-Id: <1225759967.12673.521.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 01:29 +0100, Rafael J. Wysocki wrote:
> > Since zone *ranges* overlap, you can't tell to which zone a page belongs
> > simply from its address.  You need to ask the 'struct page'.
> 
> Understood.
> 
> This means that some zones may contain some ranges of pfns that correspond
> to struct pages in another zone, correct?

Yup, that's correct.

The patch looks good to me.

-- Dave

