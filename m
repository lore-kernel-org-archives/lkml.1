Return-Path: <linux-kernel-owner+w=401wt.eu-S936946AbXGMPmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936946AbXGMPmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbXGMPmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:42:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60475 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbXGMPmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:42:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 17:50:31 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200707130808.31109.a1426z@gawab.com> <200707131828.54094.a1426z@gawab.com>
In-Reply-To: <200707131828.54094.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131750.31309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 July 2007 17:28, Al Boldi wrote:
> Rafael J. Wysocki wrote:
> > We have quite an efficient restoration code in the kernel right now.  It's
> > able to upload big images (something like total RAM minus the size of the
> > boot kernel, initrd and, optionally, the resume application), which is
> > much more than we're able to save. :-)
> >
> > It can work with images uploaded via /dev/snapshot from the user space
> > (specific image format is required, but that can be changed easily).
> 
> Then all that is need is to dump /dev/oldmem under the hibernate kernel and 
> then feed it into /dev/snapshot when booting the normal kernel.
> 
> Or is there more to it?

Not really.  Please see my recent message in the other branch of this thread.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
