Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYL0O1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYL0O1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 09:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYL0O1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 09:27:16 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:50872 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbYL0O1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 09:27:15 -0500
Message-ID: <001001c9682f$33186c40$6602a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: "\"Alex Bennee\"" <kernel-hacker@bennee.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Calculating CONFIG's from lsmod info
Date: Sat, 27 Dec 2008 15:27:08 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Provags-ID: V01U2FsdGVkX1/6hFn5DJtL5i0AXNHYuwods0FsYbKFz6fa/+VP
	uUWkgD+NhzNMHCzdtGx3YaEZHdXd80n9yhCFh+eE3xlkNEf/Qd
	53J2jzVcY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe http://cateee.net/autokernconf/ is worth to take a look at.....

roland



List:       linux-kernel
Subject:    Calculating CONFIG's from lsmod info
From:       "Alex Bennee" <kernel-hacker () bennee ! com>
Date:       2008-12-27 11:31:01
Message-ID: b2cdc9f30812270331g3435e0b1wb28573c4e6782e9 () mail ! gmail ! 
com
[Download message RAW]

Hi,

Following a conversation with my Dad concerning his new netbook we
discussed one option for speeding up the boot process was a static
kernel with the correct config for his actual hardware, obviating the
need for initrd and the rest of the flexible hardware hackery. However he 
has
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


