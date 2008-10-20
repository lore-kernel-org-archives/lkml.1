Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYJTXDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYJTXDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYJTXDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:03:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17264 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbYJTXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:03:00 -0400
Message-ID: <48FD0DEE.7000302@oracle.com>
Date: Mon, 20 Oct 2008 16:02:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] misc: replace remaining __FUNCTION__ with __func__
References: <1224543608.31861.228.camel@brick>
In-Reply-To: <1224543608.31861.228.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> These are the last occurences in-tree that are not already coming
> through a subsystem tree.
> 
> xtensa, staging and blackfin (serial driver and a fb driver) will
> catch the remaining ones as they merge.
> 
>  Documentation/DocBook/kernel-hacking.tmpl |    2 +-
>  arch/arm/mach-iop13xx/include/mach/time.h |    4 ++--
>  arch/arm/mach-pxa/include/mach/zylonite.h |    4 ++--
>  arch/powerpc/include/asm/ptrace.h         |    2 +-
>  drivers/net/usb/pegasus.c                 |    4 ++--
>  5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
> index 4c63e58..ae15d55 100644
> --- a/Documentation/DocBook/kernel-hacking.tmpl
> +++ b/Documentation/DocBook/kernel-hacking.tmpl
> @@ -1105,7 +1105,7 @@ static struct block_device_operations opt_fops = {
>      </listitem>
>      <listitem>
>       <para>
> -      Function names as strings (__FUNCTION__).
> +      Function names as strings (__func__).
>       </para>
>      </listitem>
>      <listitem>

Ack that part.

Thanks.
