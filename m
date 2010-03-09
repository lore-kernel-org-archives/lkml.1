Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0CIKLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:11:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:33714 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab0CIKLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:11:36 -0500
Date: Tue, 9 Mar 2010 11:11:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: mickib1@gmail.com, chatty@enac.fr, peterhuewe@gmx.de, micki@n-trig.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] HID: N-trig MTM Driver fix and cleanup patch 1
In-Reply-To: <4B959B69.80705@seas.upenn.edu>
Message-ID: <alpine.LNX.2.00.1003091107460.17799@pobox.suse.cz>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com> <4B959B69.80705@seas.upenn.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Rafi Rubin wrote:

> > + *	1.0 - Rafi Rubin ( Version From 2010-02-13 02:13:05)
> > + *		This cleans up the identification of multitouch
> > + *		groups and enables the end of group sync.
> > + *		Taps are now explicitly handled to adjust for the changes in
> > the
> > + *		event stream in multitouch mode.
> > + *		Added triple and quad tap for the benefit of
> > + *		tools that recognize different tap types but
> > + *		do not have full multi touch support.
> > + *	1.1 - N-trig - Add Change Log and defines of MTM firmware.
> > + *		Add debug Paramater change Driver name in hid_driver structure
> >    */
> 
> I don't know that the change log needs to be in the code file itself. The
> point was more that your commit messages should give us an idea about what
> your changing.  Jiri, what's your take on that?

Fully agreed. I am all for removing any Changelog entries from the .c 
source files altogether. We have excellent SCM to handle this all for us.

> Thank you, we should have named these constants earlier.
> 
> > +#define MODULE_NAME "hid_ntrig"
> > -	.name = "ntrig",
> 
> I left off the "hid_" prefix based on what I saw in the other hid drivers.
> Jiri, is there a standard to follow or do you have an opinion about this?

The convention used by all the other drivers hanging on HID bus are 
without the 'hid' prefix, so we should obey that also for ntrig, yes.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
