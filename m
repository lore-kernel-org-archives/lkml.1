Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZJZRBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZJZRBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZJZRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:01:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43165 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZJZRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:01:15 -0400
Date: Mon, 26 Oct 2009 12:46:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026164645.GD2792@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091020090627.f36130fb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020090627.f36130fb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 09:06:27AM -0700, Randy Dunlap wrote:
> On Tue, 20 Oct 2009 14:17:07 +0900 John W. Linville wrote:
> 
> > Move the strip ("Starmode Radio IP") driver to drivers/staging.  For
> > several years this driver has only seen API "bombing-run" changes, and
> > few people ever had the hardware.  This driver represents unnecessary
> > ongoing maintenance for no clear benefit.
> > 
> > This patch brought to you by the "hacking" session at the 2009 Kernel
> > Summit in Tokyo, Japan...
> 
> is drivers/staging/ a temporary home or a permanent home?

I would presume it to be "permanent until removed"...

> so no explanation of what it means to be in drivers/staging/ and
> no warning to users?  either in Kconfig or in feature-removal-schedule.txt?

Moving it to staging _is_ the warning.  As for the removal schedule,
I imagined that Greg would "do the needful" before actually removing
the driver.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
