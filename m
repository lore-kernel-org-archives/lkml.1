Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbYDVPYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbYDVPYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761702AbYDVPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:24:28 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:39554 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbYDVPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:24:27 -0400
Date: Tue, 22 Apr 2008 11:24:26 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Will Newton <will.newton@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-ID: <20080422152426.GG19802@phobos.i.cabal.ca>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422081211.e85989ec.randy.dunlap@oracle.com> <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 04:16:17PM +0100, Will Newton wrote:
> It can be done with Kconfig. Whether it should be or not depends on
> your point of view, hence RFC. Currently __ARCH_WANT macros is the way
> syscalls are enabled and disabled across architectures. If there's
> consensus that it should be done via Kconfig that could certainly be
> implmented, but that's a different patch.
>

It's currently done in unistd.h for hysterical raisins. All new
conditional syscalls have been done in Kconfig.
