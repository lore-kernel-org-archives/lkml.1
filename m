Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZBDQrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZBDQrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZBDQrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:47:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:41593 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZBDQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:47:45 -0500
Message-ID: <4989C6A8.5050906@mvista.com>
Date: Wed, 04 Feb 2009 09:47:36 -0700
From: Dave Jiang <djiang@mvista.com>
Organization: MontaVista Software, Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Friesen <cfriesen@nortel.com>, ncunningham-lkml@crca.org.au,
       Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Doug Thompson <norsk5@yahoo.com>, bluesmoke-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: marching through all physical memory in software
References: <715599.77204.qm@web50111.mail.re2.yahoo.com>	<m1wscc7fop.fsf@fess.ebiederm.org> <49873B99.3070405@nortel.com>	<37985.1233614746@turing-police.cc.vt.edu>	<4988555B.8010408@nortel.com> <20090203222501.GC2857@elf.ucw.cz>
In-Reply-To: <20090203222501.GC2857@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be generic code, but the actual scrubbing can be architecture 
specific. You have to atomically read and write back. And each arch has 
different way of handling that. See arch/X/include/asm/edac.h

Pavel Machek wrote:
> Software memory scrub would no longer be a "driver" :-). So it should
> go into kernel/scrub or mm/scrub or maybe mm/edac or something.
> 
