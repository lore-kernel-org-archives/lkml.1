Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbYBGXQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbYBGXQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbYBGXQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:16:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbYBGXQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:16:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [GIT PATCH] suspend patches for 2.6.25-rc0
Date: Fri, 8 Feb 2008 00:14:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       stern@rowland.harvard.edu, pavel@ucw.cz
References: <200802011820.56693.lenb@kernel.org> <20080207222713.GA20549@cs.cmu.edu>
In-Reply-To: <20080207222713.GA20549@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080014.41638.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of February 2008, Jan Harkes wrote:
> On Fri, Feb 01, 2008 at 06:20:56PM -0500, Len Brown wrote:
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git suspend
> > 
> > This will update the files shown below.
> 
> The following patch,
> 
>     commit c3e94d899c864e558f938f9845ddb8c2e5d5ccd0
>     Author: Alan Stern <stern@rowland.harvard.edu>
>     Date:   Mon Nov 19 23:38:25 2007 +0100
> 
>     Hibernation: Add PM_RESTORE_PREPARE and PM_POST_RESTORE notifiers (rev. 2)
> 
> Seems to have reverted some code related to the PM_HIBERNATION_PREPARE
> notifiers in kernel/power/user.c that were added in 2.6.23 by the
> following patch,
> 
>     commit b10d911749d37dccfa5873d2088aea3f074b9e45
>     Author: Rafael J. Wysocki <rjw@sisk.pl>
>     Date:   Thu Jul 19 01:47:36 2007 -0700
> 
>     PM: introduce hibernation and suspend notifiers
> 
> I'm pretty sure this was not the intent of the new patch because it only
> tries to extend upon the former functionality and not replace it.

I haven't revert the changes.  It's only moved the notifier chain calls from
the ioctls to open/release in user.c .

Thanks,
Rafael
