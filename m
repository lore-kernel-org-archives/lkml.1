Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbZJGUlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbZJGUlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZJGUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:41:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbZJGUlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:41:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: suspend tree build failure
Date: Wed, 7 Oct 2009 22:41:54 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
References: <20091006135505.f07ee40d.sfr@canb.auug.org.au> <200910070031.55135.rjw@sisk.pl> <20091007152914.8dadf6d7.sfr@canb.auug.org.au>
In-Reply-To: <20091007152914.8dadf6d7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910072241.54869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009, Stephen Rothwell wrote:
> Hi Rafael,
> 
> On Wed, 7 Oct 2009 00:31:55 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> > Thanks for the notification.
> > 
> > Did you cross-compile it by chance?  It builds for me on native x86_64 with
> > allmodconfig, which is why I missed this issue.
> 
> I cross compile all my x86 builds as my big machines are all PowerPC.
> 
> > > I have used the version of the suspend tree from next-20091002 for today.
> > 
> > I added the #include <linux/compiler.h> to freezer.h, but obviously I couldn't
> > verify if that fixed the problem.  Hopefully it did.
> 
> My guess was wrong.  You either need to leave the __cold off the
> definition in kernel/freezer.c or move it before the function name.  No
> other function definition in the kernel is marked __cold, but several
> declarations are.
> 
> Also __cold only generates something for gcc >= 4.3 ...  I am using 4.4.

OK, I've dropped the patch altogether for now, will add it later.

Just pushed the updated tree.

Thanks,
Rafael
