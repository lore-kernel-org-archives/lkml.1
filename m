Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYINVSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYINVSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 17:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbYINVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 17:18:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41952 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbYINVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 17:18:11 -0400
Date: Sun, 14 Sep 2008 14:17:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for September 13 (3c509)
Message-Id: <20080914141757.899f71eb.randy.dunlap@oracle.com>
In-Reply-To: <20080913162344.ab395285.sfr@canb.auug.org.au>
References: <20080913162344.ab395285.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/3c509.c fails (CONFIG_PM=y) with:

drivers/built-in.o:(.data+0x7dcc): undefined reference to `el3_resume'
drivers/built-in.o:(.data+0x7e08): undefined reference to `el3_resume'

It seems that this function does not exist in the source file.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
