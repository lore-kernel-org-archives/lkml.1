Return-Path: <linux-kernel-owner+w=401wt.eu-S1751587AbYJSNim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbYJSNim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 09:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYJSNie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 09:38:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39509 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750787AbYJSNie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 09:38:34 -0400
Date: Sun, 19 Oct 2008 15:37:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 23/24] perfmon3:  kernel documentation
Message-ID: <20081019133749.GA1546@ucw.cz>
References: <48f8a9de.1d255e0a.4027.1741@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f8a9de.1d255e0a.4027.1741@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +   * int pfm_create(int flags, pfarg_sinfo_t *s);
> +
> +      This function creates a perfmon per-thread session.
> +      The flags parameter is currently unused and must be set to 0.
> +
> +      Upon return and if s is not NULL, the kernel return the list
> of available

returns?

> +      PMC and PMD registers. Tools should not assume, they have access to the
> +      entire PMU, it may be shared with other kernel subsystems, e.g., on X86
> +      the NMI watchdog timer.

How can kernel return anything?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
