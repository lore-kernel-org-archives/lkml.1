Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYE3Cbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYE3Cbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 22:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYE3Cbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 22:31:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28030 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYE3Cbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 22:31:40 -0400
Date: Thu, 29 May 2008 19:45:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [next-20080529] build error: function: i8042_platform_init
Message-Id: <20080529194506.336077d8.randy.dunlap@oracle.com>
In-Reply-To: <20080530001525.GA29604@foursquare.net>
References: <20080530001525.GA29604@foursquare.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Thu, 29 May 2008 20:15:25 -0400 Chris Frey wrote:

> Hi,
> 
> I haven't seen this on the list yet.
> 
>   CC      drivers/input/serio/serio.o
>   CC      drivers/input/serio/i8042.o
> In file included from drivers/input/serio/i8042.h:28,
>                  from drivers/input/serio/i8042.c:85:
> drivers/input/serio/i8042-x86ia64io.h: In function 'i8042_platform_init':
> drivers/input/serio/i8042-x86ia64io.h:590: error: 'i8042_nopnp' undeclared (first use in this function)
> drivers/input/serio/i8042-x86ia64io.h:590: error: (Each undeclared identifier is reported only once
> drivers/input/serio/i8042-x86ia64io.h:590: error: for each function it appears in.)
> make[2]: *** [drivers/input/serio/i8042.o] Error 1
> make[1]: *** [drivers/input/serio] Error 2
> make: *** [drivers] Error 2

Please see this thread for patches:
  http://lkml.org/lkml/2008/5/29/299


---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
