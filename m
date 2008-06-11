Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYFKRg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYFKRg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYFKRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:36:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYFKRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:36:21 -0400
Message-ID: <48500CED.4020906@zytor.com>
Date: Wed, 11 Jun 2008 10:35:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in	pat_init()
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl> <484F0F5D.8010507@zytor.com> <20080611094730.GB5889@alberich.amd.com>
In-Reply-To: <20080611094730.GB5889@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> 
> For Intel all family 0xf CPUs, and family 6 CPUs starting with model
> 15 are whitelisted.
> 

Arg, sorry, I read the code brokenly.  You're right, of course.

> There seem to be other Intel CPUs that advertise PAT support.
> See cpuinfo output at http://gentoo-wiki.com/Safe_Cflags
> E.g. Pentium M (model 13), Celeron (model 6), Pentium III (model 8).
> (Not sure how correct this information is, though)

Yes, those all have PAT enabled.

> Turn the white- into a blacklist for those remaining CPUs until they
> are verified?

Yes, that would be a suitable course of action; moving it to 
Intel-specific code.  Then the Intel people can worry about lifting the 
remaining blacklisted CPUs.

	-hpa

