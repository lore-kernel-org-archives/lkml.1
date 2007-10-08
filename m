Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbXJHWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbXJHWHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXJHWH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:07:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54169 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXJHWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:07:28 -0400
Date: Mon, 8 Oct 2007 15:07:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc9 compile error drivers/video/fbmon.c
Message-Id: <20071008150708.3d17d0c5.randy.dunlap@oracle.com>
In-Reply-To: <470AA886.4070309@aitel.hist.no>
References: <470AA886.4070309@aitel.hist.no>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Oct 2007 00:00:38 +0200 Helge Hafting wrote:

>   CC      drivers/video/fbmon.o
> drivers/video/fbmon.c: In function ‘fb_parse_edid’:
> drivers/video/fbmon.c:867: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attrib
> _’ before ‘*’ token
> drivers/video/fbmon.c:867: error: ‘block’ undeclared (first use in this func
> )
> 
> This line reads:
>     unsigned char$*block;
> 
> Source error, or is my tree simply corrupt?

Hi,
It's a space in my kernel source file.

---
~Randy
