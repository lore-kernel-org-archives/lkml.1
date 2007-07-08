Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbXGHS3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbXGHS3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbXGHS31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:29:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59752 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbXGHS30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:29:26 -0400
Date: Sun, 8 Jul 2007 19:28:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, oliver@neukum.org,
       paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070708182824.GI21668@ftp.linux.org.uk>
References: <200707050858.03638.oliver@neukum.org> <20070708123748.GB3866@ucw.cz> <E1I7Xfc-0008PO-00@dorka.pomaz.szeredi.hu> <200707082008.57879.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707082008.57879.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 08:08:56PM +0200, Rafael J. Wysocki wrote:
> Well, the system that cannot access its filesystems is not in a consistent
> state, so it generally is not reasonable to suspend or hibernate it.
> 
> In fact, NFS and similar filesystems should always be unmounted before the
> suspend/hibernation to avoid problems that may arise after the resume, if
> they become unavailable at that time.

Ah, thanks for clarifying that. [mentally putting the entire thing into
"unusable due to idiotic design imposing idiotic limitations" bin and
stepping out of this thread]
