Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbXKAFUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbXKAFUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXKAFUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:20:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55506 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbXKAFUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:20:09 -0400
Date: Thu, 1 Nov 2007 06:21:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: kbuild problem
Message-ID: <20071101052145.GA31445@uranus.ravnborg.org>
References: <20071031183900.46a0b529.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031183900.46a0b529.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 06:39:00PM -0700, Randy Dunlap wrote:
> Hi Sam,
> 
> I have daily/nightly builds + test runs that use something like:
> (but more complicated than this)
> 
> cp saved.config.file arch/$ARCH/config.default
> EXPORT KBUILD_DEFCONFIG=config.default
> make defconfig

KBUILD_DEFCONFIG is supposed to point out a file located in
arch/$(ARCH)/configs.
I assume you copy the file to that directory.

Browsing the changes to scripts/kconfig/Makefile
nothing says 'this is the bug' but I suggest you to look there
first of all. 
I do not have -git2 and -git3 handy to do a diff between.


	Sam
