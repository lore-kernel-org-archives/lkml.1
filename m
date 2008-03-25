Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYCYAdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYCYAdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 20:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYCYAdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 20:33:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51951 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbYCYAdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 20:33:39 -0400
Date: Mon, 24 Mar 2008 17:33:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Silence two kerneldoc warnings in kernel/audit.c
Message-Id: <20080324173319.9551cea1.randy.dunlap@oracle.com>
In-Reply-To: <20080325002705.GA25116@codemonkey.org.uk>
References: <20080325002705.GA25116@codemonkey.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Mon, 24 Mar 2008 20:27:05 -0400 Dave Jones wrote:

> Silence two kerneldoc warnings.
> 
> Warning(kernel/audit.c:1276): No description found for parameter 'string'
> Warning(kernel/audit.c:1276): No description found for parameter 'len'
> 
> [also fix a typo for bonus points]
> 
> Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

I've sent the same patch to the audit people... so acked-by me.

Good luck.

> --- linux-2.6.24.noarch/kernel/audit.c~	2008-03-24 20:22:32.000000000 -0400
> +++ linux-2.6.24.noarch/kernel/audit.c	2008-03-24 20:23:34.000000000 -0400
> @@ -1269,8 +1269,8 @@ static void audit_log_n_string(struct au
>  
>  /**
>   * audit_string_contains_control - does a string need to be logged in hex
> - * @string - string to be checked
> - * @len - max length of the string to check
> + * @string: string to be checked
> + * @len: max length of the string to check
>   */
>  int audit_string_contains_control(const char *string, size_t len)
>  {
> @@ -1285,7 +1285,7 @@ int audit_string_contains_control(const 
>  /**
>   * audit_log_n_untrustedstring - log a string that may contain random characters
>   * @ab: audit_buffer
> - * @len: lenth of string (not including trailing null)
> + * @len: length of string (not including trailing null)
>   * @string: string to be logged
>   *
>   * This code will escape a string that is passed to it if the string
> 
> --

---
~Randy
