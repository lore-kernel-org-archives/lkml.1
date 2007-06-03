Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbXFCUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbXFCUYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXFCUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:24:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13486 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbXFCUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:24:14 -0400
Date: Sun, 3 Jun 2007 13:23:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig variable "COBALT" is not defined anywhere
Message-Id: <20070603132309.508738b7.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain>
References: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 13:17:48 -0400 (EDT) Robert P. J. Day wrote:

> 
>   (no one's listed as the official cobalt maintainer so i thought i'd
> just throw this out there.)
> 
>   there is no Kconfig file which defines the selectable option
> "COBALT", which means that this snippet from drivers/char/nvram.c:
> 
> #  if defined(CONFIG_COBALT)
> #    include <linux/cobalt-nvram.h>
> #    define MACH COBALT
> #  else
> #    define MACH PC
> #  endif
> 
> never evaluates to true, therefore making <linux/cobalt-nvram.h>
> fairly useless, at least under the circumstances.

Maybe it should be MIPS_COBALT ?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
