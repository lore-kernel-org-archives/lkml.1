Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXLLTQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXLLTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXLLTQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:16:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbXLLTQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:16:16 -0500
Date: Wed, 12 Dec 2007 14:15:35 -0500
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       clameter@sgi.com
Subject: Re: [PATCH -mm] x86 boot : export boot_params via sysfs (forward
	to Greg)
Message-ID: <20071212191535.GB31044@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Young <hidave.darkstar@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	clameter@sgi.com
References: <1197443265.14443.59.camel@caritas-dev.intel.com> <20071212073502.GA31348@kroah.com> <1197447079.14443.82.camel@caritas-dev.intel.com> <20071212174507.GB16049@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212174507.GB16049@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 09:45:07AM -0800, Greg Kroah-Hartman wrote:

 > Well, I respectively disagree.  sysfs is NOT for exporting various
 > binary kernel structures to userspace directly.  Again, the binary files
 > in sysfs are for chunks of memory that are PASS-THROUGH from hardware to
 > userspace, with no kernel intervention at all.
 > If you really need such a thing, use debugfs, as the only rule for
 > debugfs is that there is no rules :)

Whilst on the subject, why wasn't /sys/slab done in debugfs ?
The one-value-per-file thing has gone taken to ridiculous extremes there.

Having 3641 sysfs files that most people never use permanently taking up
memory seems to be a massive waste of resources.

Nearly a third of all the sysfs files I have on my system belong to that
subtree, which is just.. wow.

	Dave

-- 
http://www.codemonkey.org.uk
