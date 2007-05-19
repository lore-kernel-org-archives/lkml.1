Return-Path: <linux-kernel-owner+w=401wt.eu-S1764077AbXESSDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764077AbXESSDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758414AbXESSDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:03:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37990 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958AbXESSDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:03:17 -0400
X-Originating-Ip: 72.143.65.211
Date: Sat, 19 May 2007 14:02:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Deepak Saxena <dsaxena@plexity.net>
cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add ip6_tunnel.h to headers_install
In-Reply-To: <20070519174857.GA1199@plexity.net>
Message-ID: <Pine.LNX.4.64.0705191358560.13309@localhost.localdomain>
References: <20070519174857.GA1199@plexity.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, Deepak Saxena wrote:

>
> The Mobile IPv6 package (http://www.mobile-ipv6.org/software/) needs
> this header file to build the tunnelctl component. The header
> already looks sanitized so is safe to export.
>
> Signed-off-by: Deepak Saxena <dsaxena@mvista.com>
>
> ---
>
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index bcd01f2..e101315 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -239,6 +239,7 @@ unifdef-y += ipc.h
>  unifdef-y += ipmi.h
>  unifdef-y += ipv6.h
>  unifdef-y += ipv6_route.h
> +unifdef-y += ip6_tunnel.h
>  unifdef-y += isdn.h
>  unifdef-y += isdnif.h
>  unifdef-y += isdn_divertif.h

  is there some understood standard for naming header files related to
IPv6?  currently, there are header files that start with any one of
"ip6_", "ipv6_" and "ip6t_" (although the latter looks like it's
specifically for netfilter stuff).

  is there meant to be a distinction between prefixes of "ipv6_" and
"ip6_"?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
