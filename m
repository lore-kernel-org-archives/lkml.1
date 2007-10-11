Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbXJKKCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbXJKKCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXJKKCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:02:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXJKKCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:02:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2 -mm] kexec based hibernation -v5
Date: Thu, 11 Oct 2007 12:17:57 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1192068833.27482.13.camel@caritas-dev.intel.com>
In-Reply-To: <1192068833.27482.13.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710111217.58473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 11 October 2007 04:13, Huang, Ying wrote:
> Kexec base hibernation has some potential advantages over uswsusp and
> TuxOnIce (suspend2). Some most obvious advantages are:

Well, I have some doubts as far as the obviousness is concerned.

> 1. The hibernation image size can exceed half of memory size easily.

This is also possible with TuxOnIce.

> 2. The hibernation image can be written to and read from almost
>    anywhere, such as USB disk, NFS.

This is possible with uswsusp, at least in theory, probably with TuxOnIce too.

> 3. It is possible to eliminate freezer from kexec based hibernation
>    implementation.

This isn't true as long as we have not changed the handling of devices
(which is in the works, but will take time).

> 4. Based on kexec/kdump implementation, the kernel code needed is
>    less.

Well, maybe.

Greetings,
Rafael
