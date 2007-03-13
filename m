Return-Path: <linux-kernel-owner+w=401wt.eu-S965671AbXCMJoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671AbXCMJoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965674AbXCMJon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:44:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965671AbXCMJol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:44:41 -0400
From: Andreas Schwab <schwab@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Giuliano Pochini <pochini@denise.shiny.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, spyro@f2s.com, rmk@arm.linux.org.uk
Subject: Re: /sys/devices/system/cpu/cpuX/online are missing
References: <20070311222652.5ea40da1.pochini@shiny.it>
	<20070312085826.GA9985@osiris.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0703122337350.25919@denise.shiny.it>
	<je6496asea.fsf@sykes.suse.de>
	<20070313090350.GA9890@osiris.boeblingen.de.ibm.com>
X-Yow: ..Hmmm...This thing is really VIBRATING! ..It's getting WARM, too!
Date: Tue, 13 Mar 2007 10:44:31 +0100
In-Reply-To: <20070313090350.GA9890@osiris.boeblingen.de.ibm.com> (Heiko
	Carstens's message of "Tue, 13 Mar 2007 10:03:50 +0100")
Message-ID: <jetzwpscjk.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens <heiko.carstens@de.ibm.com> writes:

> On Tue, Mar 13, 2007 at 01:39:25AM +0100, Andreas Schwab wrote:
>> Giuliano Pochini <pochini@denise.shiny.it> writes:
>> 
>> > I had a look at arch/powerpc/kernel/smp.c but I'm not familiar at all with 
>> > those parts of the kernel.
>> 
>> See arch/powerpc/kernel/sysfs.c:topology_init.  I don't think there is
>> anything to do here.  You probably don't have CONFIG_HOTPLUG_CPU enabled.
>
> I was referring to arch/ppc not arch/powerpc.

Sorry, I missed that part.

> But it seems that arch/ppc doesn't support cpu hotplug anyway.

I think if there is no hotplug support then the file should not be created
in the first place.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
