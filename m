Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXLZOZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXLZOZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 09:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXLZOZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 09:25:09 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:52541 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXLZOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 09:25:07 -0500
Date: Wed, 26 Dec 2007 09:24:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>, lguest@ozlabs.org,
       glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 02/16] adapt lguest launcher to per-cpuness
In-Reply-To: <200712261035.46939.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.58.0712260915090.28862@gandalf.stny.rr.com>
References: <11981576363806-git-send-email-gcosta@redhat.com>
 <11981576442148-git-send-email-gcosta@redhat.com>
 <11981576492807-git-send-email-gcosta@redhat.com> <200712261035.46939.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Dec 2007, Rusty Russell wrote:

> On Friday 21 December 2007 00:33:42 Glauber de Oliveira Costa wrote:
> > +		if (!vcpu_id) {
> > +			/*
> > +			 * Service input, then unset the BREAK to
> > +			 * release the Waker.
> > +			 */
> > +			handle_input(lguest_fd);
> > +			if (pwrite(lguest_fd, args, sizeof(args), 0) < 0)
> > +				err(1, "Resetting break");
> > +		}
>
> I hate winged comments: those two extra lines, wasted!
>

For multiple lines, wings are a Good Thing (TM). Otherwise it looks
sloppy.

  /* Service input, then unset the BREAK to
   * release the Waker. */

extra asterisk! ok then

  /* Service input, then unset the BREAK to
     release the Waker. */

Yuck, that "release" looks like it can be code, especially with parsers
that look for comments that start with some sort of /* or *

Those little wings do IMHO make the code look nicer. I know in the Linux
community, my weight compared to you is a chihuahua compared to a
St. Bernard.  But in this case, I believe others think that my collar is
prettier than yours. ;-)

Some one buy Rusty a bigger hard-drive to store those extra lines.

-- Steve

