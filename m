Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYBGXJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYBGXJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYBGXJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:09:16 -0500
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:44922 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbYBGXJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:09:14 -0500
X-Greylist: delayed 2516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 18:09:13 EST
Date: Thu, 7 Feb 2008 17:27:13 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, stern@rowland.harvard.edu,
       rjw@sisk.pl, pavel@ucw.cz
Subject: Re: [GIT PATCH] suspend patches for 2.6.25-rc0
Message-ID: <20080207222713.GA20549@cs.cmu.edu>
Mail-Followup-To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	stern@rowland.harvard.edu, rjw@sisk.pl, pavel@ucw.cz
References: <200802011820.56693.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802011820.56693.lenb@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 06:20:56PM -0500, Len Brown wrote:
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git suspend
> 
> This will update the files shown below.

The following patch,

    commit c3e94d899c864e558f938f9845ddb8c2e5d5ccd0
    Author: Alan Stern <stern@rowland.harvard.edu>
    Date:   Mon Nov 19 23:38:25 2007 +0100

    Hibernation: Add PM_RESTORE_PREPARE and PM_POST_RESTORE notifiers (rev. 2)

Seems to have reverted some code related to the PM_HIBERNATION_PREPARE
notifiers in kernel/power/user.c that were added in 2.6.23 by the
following patch,

    commit b10d911749d37dccfa5873d2088aea3f074b9e45
    Author: Rafael J. Wysocki <rjw@sisk.pl>
    Date:   Thu Jul 19 01:47:36 2007 -0700

    PM: introduce hibernation and suspend notifiers

I'm pretty sure this was not the intent of the new patch because it only
tries to extend upon the former functionality and not replace it.

Jan

