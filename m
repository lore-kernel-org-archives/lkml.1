Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0BMCNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:13:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59181 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0BMCNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:13:23 -0500
To: Andreas Petlund <apetlund@simula.no>
Cc: "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
       Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de
Subject: Re: [net-next PATCH v3 3/3] net: TCP thin dupack
References: <4B73F31F.9000204@simula.no>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Feb 2010 18:13:13 -0800
In-Reply-To: <4B73F31F.9000204@simula.no> (Andreas Petlund's message of "Thu\, 11 Feb 2010 13\:07\:59 +0100")
Message-ID: <m16361ubly.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Petlund <apetlund@simula.no> writes:

> Major changes:
>       -Possible to disable mechanisms by socket option
>       -Socket option value boundary check
>
>
> Signed-off-by: Andreas Petlund <apetlund@simula.no>
> ---
>  include/linux/sysctl.h     |    1 +
>  include/linux/tcp.h        |    4 +++-
>  include/net/tcp.h          |    1 +
>  net/ipv4/sysctl_net_ipv4.c |    7 +++++++
>  net/ipv4/tcp.c             |    7 +++++++
>  net/ipv4/tcp_input.c       |   11 +++++++++++
>  6 files changed, 30 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index d840d75..ded3f20 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -426,6 +426,7 @@ enum
>  	NET_TCP_MAX_SSTHRESH=124,
>  	NET_TCP_FRTO_RESPONSE=125,
>  	NET_TCP_FORCE_THIN_LINEAR_TIMEOUTS=126,
> +	NET_TCP_FORCE_THIN_LINEAR_DUPACK=127,

There is no need to allocate a binary sysctl here.

Eric
