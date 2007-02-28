Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbXB1VMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbXB1VMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXB1VMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:12:48 -0500
Received: from p02c11o142.mxlogic.net ([208.65.145.65]:36239 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbXB1VMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:12:47 -0500
Date: Wed, 28 Feb 2007 23:13:18 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Message-ID: <20070228211318.GB4301@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070226220152.GA29575@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226220152.GA29575@stusta.de>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 28 Feb 2007 21:15:17.0077 (UTC) FILETIME=[8B60E050:01C75B7D]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15026.001
X-TM-AS-Result: No--7.289800-4.000000-31
X-Spam: [F=0.4986714980; S=0.498(2007010901)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Subject    : ThinkPad T60: no screen after suspend to RAM
>References : http://lkml.org/lkml/2007/2/22/391
>Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
>Handled-By : Ingo Molnar <mingo@elte.hu>
>Status     : unknown

Just reproduced this in -rc2.
Another thing I noticed:
with 2.6.20, pressing Fn/F4 generates an ACPI event and triggers suspend to RAM.

On 2.6.21-rc2, after resume (when the box is accessible from network),
pressing Fn/F4 again does not seem to have any effect.


-- 
MST
