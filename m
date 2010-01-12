Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981Ab0ALWsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0ALWsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990Ab0ALWse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:48:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43056 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0ALWse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:48:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS
Date: Tue, 12 Jan 2010 23:48:58 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
References: <201001090045.33784.rjw@sisk.pl> <878wc3j6mm.fsf@pollan.anholt.net>
In-Reply-To: <878wc3j6mm.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001122348.58306.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 January 2010, Eric Anholt wrote:
> On Sat, 9 Jan 2010 00:45:33 +0100, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915: implement
> > new pm ops for i915), among other things, removed the .suspend and
> > .resume pointers from the struct drm_driver object in i915_drv.c,
> > which broke resume without KMS on my MSI Wind U100.
> > 
> > Fix this by reverting that part of commit cbda12d77ea59.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Applied, with a little comment for the next poor person having to figure
> out the difference between these two suspend/resume paths.

Linus has applied this one already.

Rafael
