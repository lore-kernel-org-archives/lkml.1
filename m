Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYFLUNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYFLUNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYFLUNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:13:31 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53809 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYFLUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:13:30 -0400
Date: Thu, 12 Jun 2008 16:13:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080612201315.GA10879@c2.user-mode-linux.org>
References: <20080610190307.GA15983@uranus.ravnborg.org> <20080611154816.GA8167@c2.user-mode-linux.org> <20080612180859.GA2271@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612180859.GA2271@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 08:08:59PM +0200, Sam Ravnborg wrote:
> Following patch will result in a building ARCH=um kernel.
> If it works I dunno.

You can just try running it.  Given its behavior with this patch so
far, it would be an excellent sign for it to figure out that it has no
root filesystem and panic.

Anyway, I can't get it to give me a UML binary.  I see this in the
build output (and V=3 doesn't make it any more verbose):


	  CHK     include/linux/compile.h
	  LINK linux

	Compilation finished at Thu Jun 12 16:11:15

but no linux or vmlinux in my output directory.

       	     	Jeff

-- 
Work email - jdike at linux dot intel dot com
