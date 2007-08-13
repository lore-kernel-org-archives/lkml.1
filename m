Return-Path: <linux-kernel-owner+w=401wt.eu-S964775AbXHMS4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775AbXHMS4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974374AbXHMSn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:43:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18131 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033381AbXHMSnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:43:55 -0400
Date: Mon, 13 Aug 2007 11:48:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       vulpyne@vulpyne.net, trivial@kernel.org, crutcher+kernel@datastacks.com
Subject: Re: [PATCH][RESEND][Trivial] Documentation: sysrq, description of
 'h' slightly inaccurate
Message-Id: <20070813114840.2bc992e6.randy.dunlap@oracle.com>
In-Reply-To: <200708042031.27618.jesper.juhl@gmail.com>
References: <200708042031.27618.jesper.juhl@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007 20:31:27 +0200 Jesper Juhl wrote:

> (Resending a patch from 21 May 2007 that never got any response)
> 
> 
> Hello,
> 
> In Documentation/sysrq.txt, the description of 'h' says that any key not 
> listed *above* will generate help. That's obviously not true since all the 
> keys listed below 'h' will do what they are described to do, not display 
> help. So change the text so that it says that any key not listed in the 
> table will generate help, which is what really happens.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Probably due to my alphabetization of the sysrq keys.

> ---
> 
>  Documentation/sysrq.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
> index ba328f2..865b271 100644
> --- a/Documentation/sysrq.txt
> +++ b/Documentation/sysrq.txt
> @@ -1,6 +1,6 @@
>  Linux Magic System Request Key Hacks
>  Documentation for sysrq.c
> -Last update: 2007-MAR-14
> +Last update: 2007-AUG-04
>  
>  *  What is the magic SysRq key?
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> @@ -78,7 +78,7 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:
>  'g'	- Used by kgdb on ppc and sh platforms.
>  
>  'h'     - Will display help (actually any other key than those listed
> -          above will display help. but 'h' is easy to remember :-)
> +          here will display help. but 'h' is easy to remember :-)
>  
>  'i'     - Send a SIGKILL to all processes, except for init.
>  
> 
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
