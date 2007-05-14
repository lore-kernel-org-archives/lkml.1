Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXENXjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXENXjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXENXjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:39:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64888 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbXENXjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:39:05 -0400
Date: Mon, 14 May 2007 16:43:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-parport@lists.infradead.org
Subject: Re: [QUESTION] parallel console configuration
Message-Id: <20070514164316.eb9bb0f9.randy.dunlap@oracle.com>
In-Reply-To: <6bffcb0e0702161123n7139afb5sd10431a160b60976@mail.gmail.com>
References: <6bffcb0e0702161123n7139afb5sd10431a160b60976@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 20:23:00 +0100 Michal Piotrowski wrote:

> Hi,
> 
> I'm trying to setup a parallel console.
> 
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> CONFIG_PRINTER=y
> CONFIG_LP_CONSOLE=y
> 
> kernel params
> console=lp0 console=tty0
> 
> System stuck on
> lp0: using parport0 (interrupt-driven).
> 
> http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20/00001.jpg
> 
> What am I doing wrong?

Hi Michal,

LP_CONSOLE didn't work for me for awhile, but it does work for me
in 2.6.22-rc1.  Have you tested it lately?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
