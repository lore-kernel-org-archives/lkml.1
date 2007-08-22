Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbXHVP5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbXHVP5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbXHVP5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:57:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbXHVP5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:57:02 -0400
Message-ID: <46CC5CBA.2050901@redhat.com>
Date: Wed, 22 Aug 2007 11:56:42 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.17 review 35/58] forcedeth bug fix: realtek phy
References: <20070822083844.%N@1wt.eu> <20070822084026.%N@1wt.eu>
In-Reply-To: <20070822084026.%N@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2007 05:39 AM, Willy Tarreau wrote:
> This patch contains errata fixes for the realtek phy. It only renamed the
> defines to be phy specific.
> 
> Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  drivers/net/forcedeth.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> index c383dc3..dbfdbed 100644
> --- a/drivers/net/forcedeth.c
> +++ b/drivers/net/forcedeth.c
> @@ -554,6 +554,7 @@ union ring_type {
>  #define PHY_OUI_MARVELL	0x5043
>  #define PHY_OUI_CICADA	0x03f1
>  #define PHY_OUI_VITESSE	0x01c1
> +#define PHY_OUI_REALTEK	0x01c1
>  #define PHYID1_OUI_MASK	0x03ff
>  #define PHYID1_OUI_SHFT	6
>  #define PHYID2_OUI_MASK	0xfc00

Realtek is 0x0732

This is still wrong upstream -- what happened to the patch to fix it?


