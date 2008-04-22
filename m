Return-Path: <linux-kernel-owner+w=401wt.eu-S1764252AbYDVPVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764252AbYDVPVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYDVPVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:21:24 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:48202 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYDVPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:21:23 -0400
Date: Tue, 22 Apr 2008 11:21:22 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-ID: <20080422152122.GF19802@phobos.i.cabal.ca>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:13:39PM +0100, Will Newton wrote:
> Hi,
> 
> This patch introduces a __ARCH_WANT_SYS_SYSFS #define for
> architectures that support the sysfs(2) system call. At the moment
> that's everybody but blackfin, but future architectures may want to
> save the (admittedly small) code size that it adds to the kernel as
> well.
> 

This should (imnsho, at least),
	1 - Add a cond_syscall for sys_sysfs to sys_ni.c
	2 - Use a CONFIG_EMBEDDED dependent option that defaults on,
	    possibly depend on BLACKFIN if you really want to.

Adding this junk to every arch header is, in my opinion, completely
unacceptable just because blackfin wants to be different.

--Kyle
