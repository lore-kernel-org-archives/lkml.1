Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXJOPkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXJOPkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXJOPkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:40:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbXJOPkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:40:45 -0400
Date: Mon, 15 Oct 2007 11:40:31 -0400
From: Dave Jones <davej@redhat.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, Andi Kleen <andi@firstfloor.org>,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][try 2] architectural pstate driver for powernow-k8
Message-ID: <20071015154031.GA30754@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Whitcroft <apw@shadowen.org>,
	Mark Langsdorf <mark.langsdorf@amd.com>,
	Andi Kleen <andi@firstfloor.org>, cpufreq@lists.linux.org.uk,
	linux-kernel@vger.kernel.org
References: <200710091446.38432.mark.langsdorf@amd.com> <p73fy0k3ve8.fsf@bingen.suse.de> <200710091543.21350.mark.langsdorf@amd.com> <20071011075958.GK1130@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011075958.GK1130@shadowen.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 08:59:58AM +0100, Andy Whitcroft wrote:
 
 > >  	/* get fid did for hardware pstate transition */
 > >  	pstate = index & HW_PSTATE_MASK;
 > > -	if (pstate > MAX_HW_PSTATE)
 > > +	if (pstate > data->max_hw_pstate);
 > >  		return 0;
 > 
 > checkpatch picked up this dodgy if.  I suspect that the ';' is wrong
 > from the context.
 
Indeed.  Mark/Andreas, want to send me a new patch against latest
Linus HEAD ?  I didn't apply the old one yet, as it conflicted with
the changes already queued for merging.

Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
