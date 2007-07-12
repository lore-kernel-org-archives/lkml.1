Return-Path: <linux-kernel-owner+w=401wt.eu-S935005AbXGLUqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005AbXGLUqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbXGLUqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:46:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56893 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbXGLUqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:46:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/2] Kexec jump: Hibernation image operations
Date: Thu, 12 Jul 2007 22:54:15 +0200
User-Agent: KMail/1.9.5
Cc: "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167834.12556.14.camel@caritas-dev.intel.com> <20070712093808.GF1866@elf.ucw.cz>
In-Reply-To: <20070712093808.GF1866@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122254.16695.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 11:38, Pavel Machek wrote:
> On Wed 2007-07-11 15:30:34, Huang, Ying wrote:
> > This patch make it possible to have multiple implementations of
> > hibernation image operations such as write, read, check, etc, and they
> > can be switched at run time through writing the
> > "/sys/power/hibernation_image_ops". The uswsusp is the default
> > implementation.
> 
> Umm, so you hook into hibernation_ops, only to run kexec from it?
> 
> Would it make more sense to just run kexec manually, maybe with some
> parameter saying "prepare devices before"?

Well, I think that the $subject patch is unnecessary and confusing.  Instead,
I'd like to have a separate interface to invoke the feature provided by the
second patch.

What the second patch achieves, as far as I understand it, is the ability to be
able to jump between two kernels back and forth, on i386.  Although it may
generally be useful for hibernation, IMO it has very little to it right now,
because _many_ important elements of the infrastructure are still needed.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
