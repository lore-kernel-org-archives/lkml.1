Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbXB0Xji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbXB0Xji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXB0Xji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:39:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:35193 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXB0Xjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:39:37 -0500
Date: Tue, 27 Feb 2007 15:36:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Menuconfig has butterfly effects?
Message-Id: <20070227153616.712508c6.randy.dunlap@oracle.com>
In-Reply-To: <200702271812.42616.rob@landley.net>
References: <200702271812.42616.rob@landley.net>
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

On Tue, 27 Feb 2007 18:12:42 -0500 Rob Landley wrote:

> I ran "make ARCH=x86_64 menuconfig", did a lot of editing, and saved 
> the .config.  Then I copied that to a backup, ran "make oldconfig" on the 
> config I'd just saved, and compared it with the backup:
> 
> --- .config     2007-02-27 18:10:01.000000000 -0500
> +++ tryit       2007-02-27 18:09:09.000000000 -0500
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
>  # Linux kernel version: 2.6.20
> -# Tue Feb 27 18:10:01 2007
> +# Tue Feb 27 18:08:41 2007
>  #
>  CONFIG_X86_64=y
>  CONFIG_64BIT=y
> @@ -120,6 +120,9 @@
>  # CONFIG_PREEMPT_VOLUNTARY is not set
>  # CONFIG_PREEMPT is not set
>  CONFIG_ARCH_FLATMEM_ENABLE=y
> +# CONFIG_FLATMEM_MANUAL is not set
> +# CONFIG_DISCONTIGMEM_MANUAL is not set
> +# CONFIG_SPARSEMEM_MANUAL is not set
>  CONFIG_FLATMEM=y
>  CONFIG_FLAT_NODE_MEM_MAP=y
>  # CONFIG_SPARSEMEM_STATIC is not set
> 
> The first hunk I expect, the second I did not.  Anybody care to venture a 
> guess why the visibility logic is unstable?

can we get .config^Wtryit ?  (version 0, not version 1)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
