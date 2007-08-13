Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbXHMUEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbXHMUEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbXHMUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:04:28 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:46278 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXHMUE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:04:27 -0400
Message-ID: <46C0B8EA.9080405@student.ltu.se>
Date: Mon, 13 Aug 2007 22:02:50 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [2/2many] - FInd the maintainer(s) for a patch -	MAINTAINERS
References: <1186985416.10249.13.camel@localhost>
In-Reply-To: <1186985416.10249.13.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> It helps when you do the diff the right way.
>
> Describe the new F: pattern
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d3a0684..0d7f856 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -83,6 +83,13 @@ S: Status, one of the following:
>  			it has been replaced by a better system and you
>  			should be using that.
>  
> +F: Files and directories with wildcard patterns.
> +   A trailing slash includes all files and subdirectory files.
> +	F:	drivers/net/	all files in and below drivers/net
> +	F:	drivers/net/*	all files in drivers/net, but not below
> +	F:	*/net/*		all files in "any top level directory"/net
> +   One pattern per line.  Multiple F: lines acceptable.
> +
>  3C359 NETWORK DRIVER
>  P:	Mike Phillips
>  M:	mikep@linuxtr.net
>
>   
Just to be clear, which one is picked with a patch for drivers/net/foo? 
Both or the most common one?

SUBSYSTEM1
P: Person 1
F: */net/

SUBSYSTEM2
P: Person 2
F: drivers/net/


Richard "the Perl-illiterate" Knutsson

