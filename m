Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYACKnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYACKnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYACKnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:43:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58394 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYACKnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:43:40 -0500
Date: Thu, 3 Jan 2008 11:43:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [RFC][PATCH 3/7] ACPI: Separate disabling of GPEs from _PTS
Message-ID: <20080103104345.GB1732@elf.ucw.cz>
References: <200712271903.53961.rjw@sisk.pl> <200712271916.28675.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712271916.28675.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The preparation to enter an ACPI system sleep state is now tied to
> the disabling of GPEs, but the GPEs should not be disabled before
> suspending devices.  Since on ACPI 1.0x systems the _PTS global
> control method should be executed before suspending devices, we
> need to disable GPEs separately.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks ok to me... as does rest of the series.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
