Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbXK2QzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbXK2QzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbXK2QzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:55:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33863 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbXK2Qy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:54:59 -0500
Date: Thu, 29 Nov 2007 08:53:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Roland Dreier <rdreier@cisco.com>,
       Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071129085334.5793a922@laptopd505.fenrus.org>
In-Reply-To: <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net>
References: <20071122343.446909000@suse.de>
	<adatznarrzc.fsf@cisco.com>
	<200711261228.15155.rusty@rustcorp.com.au>
	<20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 10:25:33 -0800
> 
> Agreed. On first glance, I was intrigued but:
> 
> 1) Why is everyone so concerned that export symbol space is large?
> 	- does it cost cpu or running memory?

yes. about 120 bytes per symbol

> 	- does it cause bugs?

yes, bad apis are causing bugs... sys_open is just the starter of that.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
