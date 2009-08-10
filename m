Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZHJUFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZHJUFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZHJUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:05:38 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:51944 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZHJUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:05:37 -0400
Date: Mon, 10 Aug 2009 22:05:26 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <gregkh@suse.de>
Cc: Martyn Welch <martyn.welch@gefanuc.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090810200526.GC3055@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <20090810162826.GA27912@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810162826.GA27912@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sun, Aug 09, 2009 at 02:17:16PM +0200, Emilio G. Cota wrote:
> > > Instead of using that we implemented a heretic IOCTL-based
> > > interface for user-space; at least with it you could create a
> > > driver (with no interrupt support) for a device in user-space.
> 
> Why not just use the UIO interface instead of creating
> yet-another-kernel/user-api?
> 
> Will that interface not work for what you want to use here?

Certainly. I didn't mean we'd like to see that merged. Currently
we make extensive use of IOCTLs because we are maintaining
kernel and user-space code for two platforms/OSes (ppc-lynx and
x86-linux), and not having access to lynx' source code doesn't
help. So IOCTLs are pretty much everywhere, much to my regret.

E.
