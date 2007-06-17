Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbXFQVNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbXFQVNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXFQVNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:13:47 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52471 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751692AbXFQVNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:13:46 -0400
Date: Sun, 17 Jun 2007 23:13:38 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617211338.GA24771@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617204904.GB3430@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 04:49:04PM -0400, Dave Jones wrote:
> That's pretty bad corruption indeed.  What I'm puzzling over though
> is why other 965G users aren't seeing the same thing.
> My own 965G seems to be fine, though that's using Intel graphics
> instead of nvidia.
> 
> (Just to rule it out, I'm assuming at this stage in boot that the
>  nvidia driver module has never been loaded?)

Doesn't even exist for that kernel. I only compiled a new
nvidia driver module for one kernel - the one that I am using
on a daily basis.

> And if you never load the agpgart modules, you never see lockups?

What would the name be of such module?

In fact, I think that when the kernel does NOT lockup, it
doesn't print this "agpgart: Detected.." line either.

Ie, the dmesg of cf68676222e54cd0a31efd968da00e65f9a0963f
which boots fine, gives:

$ grep Detected dmesg-cf686
time.c: Detected 2666.669 MHz processor.
Detected 16.666 MHz APIC timer.

$ grep agpgart dmesg-cf686
Linux agpgart interface v0.102 (c) Dave Jones


Does that give an indication of what you want me to test/try?

-- 
Carlo Wood <carlo@alinoe.com>
