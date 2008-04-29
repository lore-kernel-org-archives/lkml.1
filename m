Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYD2PIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYD2PIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbYD2PIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:08:11 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:49084 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbYD2PIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:08:10 -0400
Message-ID: <481739BF.8010305@freescale.com>
Date: Tue, 29 Apr 2008 10:07:43 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com>
In-Reply-To: <20080428015151.GW20457@bakeyournoodle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds wrote:

> On most linux systems echo supports c-syle escapes with "-e".  I'm
> guessing which ever echo you're getting dosesn't do that.

Yes, that is my problem.

> I think the best fix is to ensure you're getting bash as your shell.

The script starts off with this line:

#!/bin/sh

Doesn't that mean that it should be interpreted by sh and not bash?

> A nasty hack would be to make check-lxdialog.sh do something like:
> (echo ' #include CURSES_LOC';echo 'main() {}') | gcc '-DCURSES_LOC=<ncurses.h>' -DLOCALE -DKBUILD_NO_NLS -lncurses -xc - -o .lxdialog.tmp

This works.  Do you think if I posted a patch that makes this change, it will be
accepted?

-- 
Timur Tabi
Linux kernel developer at Freescale
