Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0BVIlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 03:41:25 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:35037 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0BVIlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 03:41:24 -0500
Date: Mon, 22 Feb 2010 09:26:59 +0100
From: Jens Seidel <jensseidel@users.sf.net>
To: linux-kernel@vger.kernel.org
Subject: CE: xen increasing min_delta_ns to 7651397591976463850 nsec
Message-ID: <20100222082657.GA26436@merkur.sol.de>
Mail-Followup-To: Jens Seidel <jensseidel@users.sf.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX1818qG9dubc5up4V4ENznNzVVGAbzcOZ7YzJOm8
	aNo4ZXHa6qqNyljjJ3u/qMOTzQnxLIvLfIGlJJUl2ewwqwVEiM
	Dg/Rw+0cY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using vanilla 2.6.32.7 domU kernel with Xen 3.2 and get very often a
unresponsible system after approximately one or two days with messages such as

[43616.674502] CE: xen increasing min_delta_ns to 16086592372704132408 nsec
[43616.674502] CE: xen increasing min_delta_ns to 5683144485346646996 nsec
[43616.674502] CE: xen increasing min_delta_ns to 17748088764874746302 nsec
[43616.674502] CE: xen increasing min_delta_ns to 17398761110457343644 nsec
[43616.674502] CE: xen increasing min_delta_ns to 7651397591976463850 nsec
[43616.674502] CE: xen increasing min_delta_ns to 2253724351109919966 nsec
[43616.674502] CE: xen increasing min_delta_ns to 3380586526664879948 nsec
[43616.674502] CE: xen increasing min_delta_ns to 5070879789997319922 nsec
[43616.674502] CE: xen increasing min_delta_ns to 7606319684995979882 nsec
[43616.674502] CE: xen increasing min_delta_ns to 11409479527493969822 nsec
[43616.674502] CE: xen increasing min_delta_ns to 17114219291240954732 nsec

on the console. I fail to login via ssh and even to cleanly shutdown this
system via xm <id> shutdown. sysrq requests still work.

I searched the net but found only messages with 15000 nsec. My values are a
little bit larger :-)) Found references to the kernel parameter notsc and
tried it but the problem remains.

The problem started once I upgraded the kernel from 2.6.26 to 2.6.32.7.
I changed from 32bit to 64bit but apart from this I did only a make oldconfig.
That's why I think it's not my config which causes trouble.

Any ideas? Is it a known problem?

PS: Please CC: me.

Jens
