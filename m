Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYBKQZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYBKQZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbYBKQZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:25:26 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:64324 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbYBKQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:25:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=M+ueAQio4Ay9YblpuSVVLZpI1AOPwrk/rCB8Ktr+Kek7yROhMObHQ+sKGUE69IU79H7Da1w5h5BktibdnmxXSUsgv8UedXMqhgeVI/egATc9y/yNHeKdScsS7y07MlKUDW5WokUzrUUFCglFu8g9WLVRtAEoCkfEerzQYQvWqnA=
Date: Mon, 11 Feb 2008 11:25:20 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Paul Mundt <lethal@users.sourceforge.net>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] SH/Dreamcast - joystick (Control pad)
Message-ID: <20080211112433.ZZRA012@mailhub.coreip.homeip.net>
References: <1202684222.6237.9.camel@localhost.localdomain> <200802101922.29214.vapier@gentoo.org> <15561.85.118.17.158.1202739603.squirrel@newgolddream.dyndns.info> <200802111119.23841.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111119.23841.vapier@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:19:22AM -0500, Mike Frysinger wrote:
> On Monday 11 February 2008, Adrian McMenamin wrote:
> > On Mon, February 11, 2008 12:22 am, Mike Frysinger wrote:
> > > no remove function ?  looks like the probe() forces a connect, but
> > > there's no remove() to force a disconnect ...
> >
> > Removing these devices (or any other plugged directly into the maple
> > ports) is a quick way to destroy your Dreamcast: hence they were never
> > implemented I guess. But there is no convincing reason for the software
> > not doing so, I suppose. I can just put in comments about it.
> 
> and not allow the driver to be built as a module until the comments become 
> code ...
> -mike

Normally drivers can be unbound from devices via sysfs even if they are
built-in, not modules.


-- 
Dmitry
