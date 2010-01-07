Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655Ab0AGNDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0AGNDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590Ab0AGNDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:03:51 -0500
Received: from mga06.intel.com ([134.134.136.21]:5478 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752584Ab0AGNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:03:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,235,1262592000"; 
   d="scan'208";a="585144030"
Message-ID: <4B45DBB5.9070904@linux.intel.com>
Date: Thu, 07 Jan 2010 05:03:49 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-15?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markup_oops.pl get error in x86
References: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com> 	<4B448EE3.5060200@linux.intel.com> <daef60381001062143i67da4203rb02919b64794664c@mail.gmail.com>
In-Reply-To: <daef60381001062143i67da4203rb02919b64794664c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2010 21:43, Hui Zhu wrote:
>
> What about this version?

looks great to me,

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

>
> Thanks,
> Hui
>
> ---
>   scripts/markup_oops.pl |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -154,7 +154,7 @@ while (<STDIN>) {
>   	if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
>   		$target = $1;
>   	}
> -	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
> +	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
>   		$function = $1;
>   		$func_offset = $2;
>   	}

