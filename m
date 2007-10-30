Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbXJ3WcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbXJ3WcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXJ3WcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:32:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36060
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbXJ3WcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:32:10 -0400
Date: Tue, 30 Oct 2007 15:31:54 -0700 (PDT)
Message-Id: <20071030.153154.241148799.davem@davemloft.net>
To: sam@ravnborg.org
Cc: raa.lkml@gmail.com, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in
 exported headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030222025.GA19792@uranus.ravnborg.org>
References: <20071030.145926.219328422.davem@davemloft.net>
	<20071030.150537.240140474.davem@davemloft.net>
	<20071030222025.GA19792@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 30 Oct 2007 23:20:25 +0100

> On Tue, Oct 30, 2007 at 03:05:37PM -0700, David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Tue, 30 Oct 2007 14:59:26 -0700 (PDT)
> > 
> > > I think the thing to do is just __KERNEL__ protect the
> > > <linux/string.h> include and require userspace to
> > > include <string.h> itself when using these headers.
> > > 
> > > That's what I'm testing right now.
> > > 
> > > I'm pretty sure those inlines are indeed used by userspace.
> > 
> > Actually, I'm tempted to put <string.h> in the ifndef __KERNEL__
> > block of that header.
> 
> Something like this..
> I like it - much better than adding string.h to unidef-y.
> PS - had not pulled latest -linus - so you must update Kbuild.
> PPS - tipc.h should be exported too as I understood Stephen.

tipc.h is already listed in header-y.

I'll merge your patch, thanks Sam.
