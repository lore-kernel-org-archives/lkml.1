Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYI3V37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYI3V37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYI3V3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:29:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:20387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYI3V3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:29:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,340,1220252400"; 
   d="scan'208";a="386158571"
Date: Tue, 30 Sep 2008 14:29:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/2] x86: Handle error returns in set_memory_*
Message-ID: <20080930212949.GL15609@linux-os.sc.intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.970641000@linux-os.sc.intel.com> <20080913000051.970641000@linux-os.sc.intel.com> <20080914141012.GA17727@elte.hu> <200809301036.05207.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809301036.05207.elendil@planet.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 01:36:04AM -0700, Frans Pop wrote:
> As I mentioned before, I only tested with the first of the two patches
> (as you asked me to) and that solved the artifacts for me. What's the
> explanation behind that?
> 
> What is the relationship between the first and second patch?

Frans, There is no relationship between the two patches. First patch
(track memtype for RAM in page struct) will fix the behavior you
observed and the second patch addresses some error conditions which
were noticed by Venki.

Both should have been pushed independently.

thanks,
suresh
