Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbXKNTQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbXKNTQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXKNTP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:15:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59235 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbXKNTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:15:59 -0500
Date: Wed, 14 Nov 2007 20:15:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Philippe Elie <phil.el@wanadoo.fr>
Cc: William Cohen <wcohen@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Stephane Eranian <eranian@hpl.hp.com>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114191556.GA32238@one.firstfloor.org>
References: <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com> <20071114020702.GB20365@one.firstfloor.org> <20071114130909.GB6557@frankl.hpl.hp.com> <20071114142411.GD17145@one.firstfloor.org> <473B17D4.5050702@redhat.com> <20071114185340.GB2894@zaniah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114185340.GB2894@zaniah>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, isn't rdpmc only enable for ring 0 on linux ? I remember a patch
> to disable it, dunno if it has been applied.

Obviously -- without a system call to set up performance counters it
would be fairly useless. But of course once such system calls are in
they should be able to trigger the bit for each process.

-Andi
