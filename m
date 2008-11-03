Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYKCWal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYKCWal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYKCWaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:30:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58121 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYKCWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:30:30 -0500
Date: Mon, 3 Nov 2008 22:30:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
Message-ID: <20081103223026.GA9118@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <20081103142346.05d93b0d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103142346.05d93b0d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 02:23:46PM -0800, Andrew Morton wrote:

> However, what worries me a bit is how our users are to understand
> whether they need to use this option, how to use it, etc.  Does it
> require too much knowledge of PCIE internals to be very useful?  Is
> there any way in which we can make it more user-friendly?

I'd lean towards this being the default behaviour in the long run, but 
right now there's not a great deal of understanding of what the failure 
cases may be. We're planning to give it a go in Fedora and see what the 
feedback from that is.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
