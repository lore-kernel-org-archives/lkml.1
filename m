Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbXKVXJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbXKVXJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 18:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbXKVXJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 18:09:40 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59924 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753243AbXKVXJk (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 18:09:40 -0500
Date: Fri, 23 Nov 2007 10:09:22 +1100
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>,
       xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122230922.GZ114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org> <20071122034106.GV114266761@sgi.com> <20071122072549.GQ19691@waste.org> <20071122103159.GW114266761@sgi.com> <20071122181029.GR19691@waste.org> <20071122222909.GY114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122222909.GY114266761@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 09:29:09AM +1100, David Chinner wrote:
> On Thu, Nov 22, 2007 at 12:10:29PM -0600, Matt Mackall wrote:
> > If I've got XFS on filesystems A and B on the same spindle (or volume
> > group?) and my real RT I/O takes place only on B, then I want log
> > flushing to happen in RT on B. But -never on A-. If I can do this with
> > a tunable, I'm perfectly happy.
> 
> No, not another mount option. I'm just going to drop this one for
> now...

Actually, I might change it to use the highest non-rt priority, which
would solve the latency issues in the normal cases and still leave
the RT rope dangling for those that want to use it.

Is that an acceptible compromise, Matt?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
