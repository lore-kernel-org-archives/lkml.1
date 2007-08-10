Return-Path: <linux-kernel-owner+w=401wt.eu-S941323AbXHJUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941323AbXHJUVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXHJUVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:21:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759175AbXHJUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:21:12 -0400
Date: Fri, 10 Aug 2007 13:20:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-Id: <20070810132019.bc218797.akpm@linux-foundation.org>
In-Reply-To: <20070810200801.GA16714@hall.aurel32.net>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<20070810200801.GA16714@hall.aurel32.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 22:08:01 +0200
Aurelien Jarno <aurelien@aurel32.net> wrote:

> On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
> > 
> > - Various problems from 2.6.23-rc2-mm1 were fixed
> > 
> 
> I have just noticed that the B44 drivers now depends on BROKEN. It was
> the already case in 2.6.23-rc2-mm1 but not 2.6.23-rc1-mm2. Is it
> something really wanted?
> 

I was leaving it that way until the ssb code all turned up in git-wireless's
#mm-master branch.  From a quick peek it seems that this has now happened,
so I'll drop that patch and see how we get on.

git-wireless now has the usual git catastrophe when merging it against the
recently-discovered net-2.6.24 tree, so I'll need to do something about
that first.

