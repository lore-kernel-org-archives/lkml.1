Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXBXASB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXBXASB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXBXASB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:18:01 -0500
Received: from terminus.zytor.com ([192.83.249.54]:34320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXBXASA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:18:00 -0500
Message-ID: <45DF842F.9000302@zytor.com>
Date: Fri, 23 Feb 2007 16:17:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: dsaxena@plexity.net
CC: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow kernel to build on Cygwin
References: <20070223034343.GA3320@plexity.net>
In-Reply-To: <20070223034343.GA3320@plexity.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Deepak Saxena wrote:
> 
> diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
> index bea5d97..ce447ff 100644
> --- a/lib/gen_crc32table.c
> +++ b/lib/gen_crc32table.c
> @@ -1,6 +1,8 @@
>  #include <stdio.h>
>  #include "crc32defs.h"
> +#ifndef __CYGWIN__
>  #include <inttypes.h>
> +#endif
>  
>  #define ENTRIES_PER_LINE 4
>  

Cygwin has <inttypes.h> just fine; what are you trying to do here?

	-hpa
