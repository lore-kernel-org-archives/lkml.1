Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYL0LbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYL0LbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYL0LbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:31:06 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:53157 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYL0LbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:31:03 -0500
Message-ID: <b2cdc9f30812270331g3435e0b1wb28573c4e6782e9@mail.gmail.com>
Date: Sat, 27 Dec 2008 11:31:01 +0000
From: "Alex Bennee" <kernel-hacker@bennee.com>
To: linux-kernel@vger.kernel.org
Subject: Calculating CONFIG's from lsmod info
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: f2eafb2a7eb6d4a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following a conversation with my Dad concerning his new netbook we
discussed one option for speeding up the boot process was a static
kernel with the correct config for his actual hardware, obviating the
need for initrd and the rest of the flexible hardware hackery. However he has
less patience than me for reading through each Kconfig entry so I'm
wondering if it's possible to come up with a solution that just works
(tm).

Given we usually know the config of the running kernel
(/proc/config.gz or some package copy of it) and the modules that have
been successfully loaded (lsmod) it must be deducible which CONFIG_*
to turn from m to y for a kernel rebuild.

The info from modinfo brings up a host of information for each module
but the CONFIG flag that selects it for building is not one of them.
Is there some sort of macro magic that could add the flag as module
information or will I be reduced to grokking Makefile to deduce which
object was invoked by which switch?

Or am I in fact re-inventing a wheel that has already been created
but isn't living in the scripts directory?

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
