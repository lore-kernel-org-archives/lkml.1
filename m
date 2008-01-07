Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYAGKMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYAGKMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYAGKMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:12:35 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52368 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbYAGKMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:12:35 -0500
Date: Mon, 7 Jan 2008 11:12:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build Failure on headers_install
Message-ID: <20080107101235.GA13609@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <4781E75B.3020307@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4781E75B.3020307@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 02:18:27PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> The make allyesconfig build fails on x86_64 (AMD box) with the following
> error
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CHK     include/linux/version.h
> make[2]: `scripts/unifdef' is up to date.
> make[2]: *** No rule to make target `|', needed by `asm-generic'.  Stop.
> make[1]: *** [headers_install] Error 2
> make: *** [vmlinux] Error 2

Which make version are you using - it looks like a make bug.
Did this occur with an older kernel or has this behaviour just started?

To get further you can disable "headers check" in kernel hacking menu
but we need to find out why it fails for you.

Note: '|' is used to say that a prerequisite is 'order only' in
scripts/Makefile.headersinst

	Sam
