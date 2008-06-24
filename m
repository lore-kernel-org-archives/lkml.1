Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYFXTXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYFXTXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYFXTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:23:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59045 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYFXTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:23:12 -0400
Date: Tue, 24 Jun 2008 21:24:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [patch 1/4] Container Freezer: Add TIF_FREEZE flag to all
	architectures
Message-ID: <20080624192404.GA18679@elf.ucw.cz>
References: <20080624135823.417569216@us.ibm.com> <20080624135823.747587186@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624135823.747587186@us.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-06-24 06:58:24, Matt Helsley wrote:
> From: Cedric Le Goater <clg@fr.ibm.com>
> Subject: [patch 1/4] Container Freezer: Add TIF_FREEZE flag to all architectures
> 
> This patch is the first step in making the refrigerator() available 
> to all architectures, even for those without power management. 
> 
> The purpose of such a change is to be able to use the refrigerator() 
> in a new control group subsystem which will implement a control group
> freezer.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
