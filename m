Return-Path: <linux-kernel-owner+w=401wt.eu-S2992898AbXDDPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992898AbXDDPH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992917AbXDDPH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:07:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58136 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992916AbXDDPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:07:57 -0400
Date: Wed, 4 Apr 2007 08:07:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bryan.wu@analog.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin arch: use boot_command_line instead of
 save_command_line in setup c file
Message-Id: <20070404080752.4c2375b2.randy.dunlap@oracle.com>
In-Reply-To: <1175668103.10608.39.camel@roc-desktop>
References: <1175668103.10608.39.camel@roc-desktop>
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

On Wed, 04 Apr 2007 14:28:23 +0800 Wu, Bryan wrote:

> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  arch/blackfin/kernel/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
> index ce51882..9870c60 100644
> --- a/arch/blackfin/kernel/setup.c
> +++ b/arch/blackfin/kernel/setup.c
> @@ -221,7 +221,7 @@ void __init setup_arch(char **cmdline_p)
>  
>  	/* Keep a copy of command line */
>  	*cmdline_p = &command_line[0];
> -	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
> +	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
>  	saved_command_line[COMMAND_LINE_SIZE - 1] = 0;
>  
>  	/* setup memory defaults from the user config */
> -- 

Hi Bryan,

Patch descriptions should include _why_ a change is being made,
not just what the change is.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
