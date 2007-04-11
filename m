Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbXDKKkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbXDKKkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXDKKkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:40:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXDKKkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:40:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: 2.6.21-rc6-mm1
Date: Wed, 11 Apr 2007 12:39:05 +0200
User-Agent: KMail/1.9.6
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com> <20070411001513.GA2975@linux-os.sc.intel.com> <20070411052007.GA24056@frankl.hpl.hp.com>
In-Reply-To: <20070411052007.GA24056@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704111239.06259.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The next kernel patch for Perfmon will not make use of the idle notification
> anymore on any platform.

What do you use instead? 

I've been actually thinking to add idle notifier support to oprofile to correct
for the "perfctr doesn't tick in idle" issue which makes numbers not add up to 100%. 
A lot of people are currently running idle=poll to work around this and that is very
wasteful.

-Andi
 
