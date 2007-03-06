Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXCFDHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXCFDHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 22:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933884AbXCFDHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 22:07:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48468 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883AbXCFDHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 22:07:01 -0500
Date: Mon, 5 Mar 2007 19:03:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Alex Williamson <alex.williamson@hp.com>,
       Kevin Stansell <kstansel@us.ibm.com>
Subject: Re: [patch] Add insmod option to force the use of the backup timer.
Message-Id: <20070305190333.c01a7ffc.akpm@linux-foundation.org>
In-Reply-To: <45E6D309.5050409@suse.de>
References: <20070228102346.115707000@suse.de>
	<20070228185505.GA17193@redhat.com>
	<45E6D309.5050409@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 14:20:09 +0100 Gerd Hoffmann <kraxel@suse.de> wrote:

> Dave Jones wrote:
> > On Wed, Feb 28, 2007 at 11:23:46AM +0100, Gerd Hoffmann wrote:
> >  > The test which automatically enables the backup timer on some HP
> >  > machines doesn't trigger on other hardware which needs the backup
> >  > timer too.
> > 
> > Did you figure out *why* that test doesn't trigger?
> 
> I didn't, probably a slightly different hardware bug.
> 
> > Making that work seems a better solution to me than adding magic
> > options that users won't know they have to use.
> 
> Sure, that would be better.  I'll leave that to the ibm guys who own the
> hardware in question ;)
> 

Well, it doens't _have_ to be the IBM guys.  Anyone who can reproduce this
problem should be able to find the suitable magic to detect the broken
interrupt generation.

An automatic fix is much preferable to a module parameter which most people
won't even know exists.

Perhaps Alex can suggest some debugging steps we can take to work out
why the test isn't triggering?
