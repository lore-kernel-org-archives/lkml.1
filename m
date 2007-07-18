Return-Path: <linux-kernel-owner+w=401wt.eu-S935292AbXGRRTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbXGRRTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935043AbXGRRSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:18:42 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:31976 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935009AbXGRRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:18:40 -0400
X-YMail-OSG: .FY5rD0VM1mOzhJb9dCYursSNEUSXv_Nkrnxa0dqBAX6QtYyXfltjhu2QWyDh.su3VDDzeejxA--
Date: Wed, 18 Jul 2007 12:18:34 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid check
Message-ID: <20070718171834.GA28855@vino.hallyn.com>
References: <20070717093008.14653.75384.sendpatchset@cselinux1.cse.iitk.ac.in> <20070717153510.GA8464@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717153510.GA8464@vino.hallyn.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Satyam Sharma (ssatyam@cse.iitk.ac.in):
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [PATCH] Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid check
> > 
> > Introduce is_owner_or_cap() macro in fs.h, and convert over relevant
> > users to it. This is done because we want to avoid bugs in the future
> 
> I like the idea - it will make future user namespace/per-container
> capability patches much cleaner by localizing a lot of the changes.
> 
> (haven't tested the patch yet, but it looks trivial enough, and I will
> test later today)

tested fine for me.

thanks,
-serge
