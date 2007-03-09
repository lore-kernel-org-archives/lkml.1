Return-Path: <linux-kernel-owner+w=401wt.eu-S2992932AbXCIDfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992932AbXCIDfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992939AbXCIDfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:35:13 -0500
Received: from ozlabs.org ([203.10.76.45]:46222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992932AbXCIDfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:35:11 -0500
Date: Thu, 8 Mar 2007 21:31:41 -0600
From: Anton Blanchard <anton@samba.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070309033141.GE24695@kryten>
References: <1173394873.3461.510.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173394873.3461.510.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Most system calls seem to get added to i386 first. This patch
> automatically generates a warning for any new system call which is
> implemented on i386 but not the architecture currently being compiled.
> On PowerPC at the moment, for example, it results in these warnings:

Love it!

...

> Thanks for the update. Quite why the PowerPC kernel defines system
> call numbers for all of these I have no idea :)

BTW while unistd.h may refer to sys_iopl etc, the actual syscall is sent
to ni_syscall in most of these useless cases.

Anton
