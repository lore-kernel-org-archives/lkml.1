Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYBKPF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYBKPF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYBKPFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:05:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37075 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYBKPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:05:17 -0500
Date: Mon, 11 Feb 2008 07:04:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support
 self-snoop
Message-ID: <20080211070430.099fbded@laptopd505.fenrus.org>
In-Reply-To: <20080211095022.7B8C31B41CE@basil.firstfloor.org>
References: <200802111050.372086035@suse.de>
	<20080211095022.7B8C31B41CE@basil.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 10:50:22 +0100 (CET)
Andi Kleen <ak@suse.de> wrote:

> 
> [2.6.25 candidate I believe]
> 
> The specification of SS in the public manuals is a little unclear,
> but I got confirmation from Intel that SS implies that there is no
> cache flush needed on caching attribute changes.

I'm hearing slightly different information, but am still chasing this one.
It might be better to delay this one to .26 ;-(
(I would very much like to avoid the cache flush but... it really HAS to be safe)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
