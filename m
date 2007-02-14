Return-Path: <linux-kernel-owner+w=401wt.eu-S1751132AbXBNG2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbXBNG2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 01:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXBNG2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 01:28:15 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:35930 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXBNG2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 01:28:14 -0500
Date: Tue, 13 Feb 2007 22:23:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: olecom@flower.upol.cz, sam@ravnborg.org, zippel@linux-m68k.org
Subject: Re: kbuild feature/question: default ARCH
Message-Id: <20070213222316.4021216f.randy.dunlap@oracle.com>
In-Reply-To: <20070213220619.ce964f58.randy.dunlap@oracle.com>
References: <20070213220619.ce964f58.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 22:06:19 -0800 Randy Dunlap wrote:

> ---
> 
> If ARCH is unspecified (command line or environment) and if
> include/asm is already a symlink to include/asm-$ARCH,
> use that ARCH as the default instead of the host ARCH.
> Undo the effect of this by using 'make mrproper' or just 'rm include/asm'.

Probably simpler just to do

$ export ARCH=i386
$ make ...

and skip this patch.  g/nite.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
