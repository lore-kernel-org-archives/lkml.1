Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbXJVTpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbXJVTpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXJVTpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:45:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:19918 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbXJVTpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=IC/YohGaZCoRO36vShHyKyKPA+aXcLAa4GKfpv1bhXO9jgVQpF1091yZLfwQ/CCR7v/Tn9/6hhsREVWvK9QuU9PIBHPXwmx1T7DWpxKGe6c34DO44rz3tT8/Je3AnmOZQLqB2PgumsyjqKdrgxE/Mu4cJe/JSXCu6u+Mmc4Vah0=
Message-ID: <471CFDCE.9090702@googlemail.com>
Date: Mon, 22 Oct 2007 21:45:18 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: appletalk bugs
References: <471CB159.1070706@googlemail.com> <m18x5vasif.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18x5vasif.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Gabriel C <nix.or.die@googlemail.com> writes:
> 
>> Hi,
>>
>> modprobing appletalk on current git gives a warning in dmesg :
>>
>> [38506.600269] sysctl table check failed: /net/appletalk .3.7 procname does not
>> match binary path procname
> 
> Oops.  My apologies it appears I made a mistake when creating my
> table to check up on sysctl values.
> 
> This should fix it.

Yes it does, thx.

> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> ---
> 
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index 3c9ef5a..ed6fe51 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -731,7 +731,7 @@ static struct trans_ctl_table trans_net_table[] = {
>  	{ NET_UNIX,		"unix",		trans_net_unix_table },
>  	{ NET_IPV4,		"ipv4",		trans_net_ipv4_table },
>  	{ NET_IPX,		"ipx",		trans_net_ipx_table },
> -	{ NET_ATALK,		"atalk",	trans_net_atalk_table },
> +	{ NET_ATALK,		"appletalk",	trans_net_atalk_table },
>  	{ NET_NETROM,		"netrom",	trans_net_netrom_table },
>  	{ NET_AX25,		"ax25",		trans_net_ax25_table },
>  	{ NET_BRIDGE,		"bridge",	trans_net_bridge_table },
> 
