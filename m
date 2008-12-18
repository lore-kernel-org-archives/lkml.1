Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752387AbYLRGyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbYLRGyO (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYLRGx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:53:57 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:41962 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYLRGx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:53:57 -0500
Date: Thu, 18 Dec 2008 06:53:54 +0000
From: Nick Warne <nick@ukfsn.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: andrew@ishiboo.com, akpm@linux-foundation.org
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS
Message-ID: <20081218065354.092d710f@sauron.linicks.net>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Wed, Dec 17, 2008 at 7:34 PM, Andrew Paprocki <andrew@ishiboo.com> wrote:
> > > I see two problems with the i8k module and the Dell XPS M1530. First,
> > > the laptop is not detected. Second, even if it is detected, the module
> > > prints that it is unable to get the SMM BIOS version even though the
> > > module appears to be working:
> > 
> > It appears that the Dell Vostro & Precision series have the same issue
> > and the driver was never updated for those as well. Patches were
> > submitted back in 2007-11 and 2008-04 respectively:
> > 
> > http://marc.info/?l=linux-kernel&m=119401935026583&w=2
> > http://marc.info/?l=linux-kernel&m=120822526223412&w=2
> 
> Thanks, I picked up all three (much to various people's surprise, I expect).
> 
> > The same message prints for (at least one of) those as well:
> > 
> > i8k: unable to get SMM BIOS version
> 
> hm.  But the driver works OK anyway?

I put in a patch once for the Dell MM061 (UK Inspiron model) with
similar issues:

http://lkml.org/lkml/2007/12/7/121

If the module doesn't recognise the version model, you have to use
'force=1'... and if that works, you still get the 'unable to detect SMM
BIOS version' message.

But all appears to function fine with the patches to include version
models.

Nick
-- 
Free Software Foundation Associate Member 5508
