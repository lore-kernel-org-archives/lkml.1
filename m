Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbYAKRT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbYAKRT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761369AbYAKRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:19:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37886 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761253AbYAKRTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:19:07 -0500
Date: Fri, 11 Jan 2008 09:18:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: dean gaudet <dean@arctic.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080111091841.04eecd54@laptopd505.fenrus.org>
In-Reply-To: <alpine.DEB.0.999999.0801110856230.9361@twinlark.arctic.org>
References: <20080103424.989432000@suse.de>
	<20080110093126.GA360@elte.hu>
	<20080110095337.GK25945@bingen.suse.de>
	<20080110100443.GB28209@elte.hu>
	<20080110100712.GO25945@bingen.suse.de>
	<20080110105726.GD28209@elte.hu>
	<20080110111248.GR25945@bingen.suse.de>
	<20080111071936.GA16175@elte.hu>
	<alpine.DEB.0.999999.0801110856230.9361@twinlark.arctic.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 09:02:46 -0800 (PST)
dean gaudet <dean@arctic.org> wrote:

> > Bulk ops (string ops, etc.) will do full cacheline writes too, 
> > without filling in the cacheline.
> 
> on intel with fast strings enabled yes.  mind you intel gives hints in
> the documentation these operations don't respect coherence... and i
> asked about this when they posted their memory ordering paper but got
> no response.

I know there's an answer on the way; it just needs to get checked by
architects for cpus we shipped in like the last 10 years ;)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
