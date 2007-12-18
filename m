Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbXLRPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbXLRPoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbXLRPoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:44:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2735 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752319AbXLRPoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:44:08 -0500
Date: Tue, 18 Dec 2007 15:43:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071218154351.GC3974@ucw.cz>
References: <20071214004710.03f37774@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214004710.03f37774@linux360.ro>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-12-14 00:47:10, Eduard-Gabriel Munteanu wrote:
> Some multiprocessor 64-bit AMD systems don't allow the user to disable
> the C1E C-state. The kernel detects C1E and marks the LAPIC as
> broken, thereby disabling dynticks. This patch adds an option to
> disable C1E when detected. It also allows the user to enable this
> processor feature even if that means disabling dynticks, which is
> useful in case C1E might provide better power savings (e.g.: C-states
> beyond C1 don't work). Tested on a Turion X2 TL-56 laptop. Thanks to
> Mikhail Kshevetskiy and FreeBSD for pointing out the relevant AMD docs.
...

> +static int __cpuinit force_amd_c1e(char *str) {

{ on new line, please.

> +	disable_amd_c1e = 0;
> +	return 1;
> +}
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
