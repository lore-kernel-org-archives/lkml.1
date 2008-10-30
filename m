Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYJ3Voy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYJ3Voy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760344AbYJ3Vol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:44:41 -0400
Received: from mail.crca.org.au ([67.207.131.56]:42691 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760335AbYJ3Vok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:44:40 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <Pine.LNX.4.44L0.0810300955020.2401-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0810300955020.2401-100000@iolanthe.rowland.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 31 Oct 2008 08:44:20 +1100
Message-Id: <1225403060.6574.10.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan.

On Thu, 2008-10-30 at 09:56 -0400, Alan Stern wrote:
> On Fri, 31 Oct 2008, Nigel Cunningham wrote:
> 
> > > Well yeah, your patch handles the straightforward cases.  But it
> > > doesn't help with the more tricky cases, where one fuse filesystem is
> > > using another, and as those may become more widespread, this approach
> > > will fail.
> > 
> > At the moment, yes. But it's not impossible for us to modify the patch
> > to handle that as well.
> 
> It depends on what you mean.  The most direct reading of your statement
> is simply wrong: It is _theoretically_ impossible to find the correct
> order for freezing filesystems.  To do so would be equivalent to
> solving the halting problem.

I'm not sure that's true. You see, I'm thinking of this as not that
different to the problem of unmounting filesystems. There, too, we need
to unmount in a particular order, and let transactions on each
filesystem stop cleanly before we can unmount them. Even if there are
differences, perhaps looking at how we handle unmounting will help with
handling freezing.

Regards,

Nigel

