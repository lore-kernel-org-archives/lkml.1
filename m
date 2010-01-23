Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404Ab0AWBV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0AWBV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941Ab0AWBVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:21:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884Ab0AWBVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:21:20 -0500
Date: Fri, 22 Jan 2010 17:21:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <teawater@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ozan =?ISO-8859-1?Q?=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markup_oops.pl get $func_offset error in x8664
Message-Id: <20100122172108.620deddc.akpm@linux-foundation.org>
In-Reply-To: <daef60381001170535q6abfd29cp1b8d07709c00e1db@mail.gmail.com>
References: <daef60381001170535q6abfd29cp1b8d07709c00e1db@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 21:35:25 +0800
Hui Zhu <teawater@gmail.com> wrote:

> This patch like the prev patch in http://lkml.org/lkml/2010/1/6/57
> The x8664 part have the same trouble with it.  This patch is to fix it.
> 

This changelog isn't very useful.  Please provide a description for this
change which doesn't require that people have to go off and read the
internet and then work out how some other patch is relevant to this
one!


> ---
>  scripts/markup_oops.pl |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -158,7 +158,7 @@ while (<STDIN>) {
>  		$function = $1;
>  		$func_offset = $2;
>  	}
> -	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\]
> ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
> +	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\]
> ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
>  		$function = $1;
>  		$func_offset = $2;
>  	}

Your email client wordwrapped the patch.  Please fix it then resend.

