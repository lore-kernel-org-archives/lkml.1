Return-Path: <linux-kernel-owner+w=401wt.eu-S1422735AbXCGLNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422735AbXCGLNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965088AbXCGLNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:13:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35644 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965057AbXCGLNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:13:05 -0500
Message-ID: <45EE9E39.3010800@garzik.org>
Date: Wed, 07 Mar 2007 06:12:57 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?TWF0?= =?UTF-8?B?aGlldSBCw6lyYXJk?= 
	<Mathieu.Berard@crans.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015036.GH3441@stusta.de>
In-Reply-To: <20070305015036.GH3441@stusta.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : NCQ problem with ahci and Hitachi drive
> References : http://lkml.org/lkml/2007/3/4/178
> Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
> Status     : unknown

according to the last message in that thread, it sounds like ACPI and 
interrupt problems


> Subject    : SATA_ACPI errors during kernel boot
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8080
>              http://bugzilla.kernel.org/show_bug.cgi?id=8046
>              http://bugzilla.kernel.org/show_bug.cgi?id=8095
>              http://lkml.org/lkml/2007/2/22/159
> Submitter  : Janosch Machowinski <jmachowinski@gmx.de>
>              Lukas Hejtmanek <xhejtman@fi.muni.cz>
>              Meelis Roos <mroos@linux.ee>
>              Olivier Mondoloni <darkcore71@yahoo.fr>
> Handled-By : Thomas Renninger <trenn@suse.de>
>              Tejun Heo <htejun@gmail.com>
>              Robert Moore <robert.moore@intel.com>
> Status     : problem is being debugged

Note that there WILL be an increase in ACPI diagnostic output.  The key 
difference is whether the users are seeing scary printks, or whether the 
boot is actually breaking.

	Jeff


