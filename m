Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYFKJsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYFKJsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYFKJsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:48:07 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6699 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYFKJsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:48:05 -0400
X-BigFish: VPS-29(z34a4nz1432R98dR7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K2ALVR-01-KG4-01
Date: Wed, 11 Jun 2008 11:47:30 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in
	pat_init()
Message-ID: <20080611094730.GB5889@alberich.amd.com>
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl> <484F0F5D.8010507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <484F0F5D.8010507@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jun 2008 09:47:31.0738 (UTC) FILETIME=[2B0E97A0:01C8CBA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 04:33:49PM -0700, H. Peter Anvin wrote:
> Rene Herman wrote:
>> The current setup is okay really. The only thing it still wants is a 
>> commandline whitelist switch but that needs a somewhat different setup as 
>> validate_pat_support() is too early for __setup() or early_param().
>
> Actually, I think it's time to nuke the whitelist.  I don't think it has 
> any CPUs on it that have the PAT flag enabled, still.

For Intel all family 0xf CPUs, and family 6 CPUs starting with model
15 are whitelisted.

There seem to be other Intel CPUs that advertise PAT support.
See cpuinfo output at http://gentoo-wiki.com/Safe_Cflags
E.g. Pentium M (model 13), Celeron (model 6), Pentium III (model 8).
(Not sure how correct this information is, though)

Turn the white- into a blacklist for those remaining CPUs until they
are verified?


Andreas


