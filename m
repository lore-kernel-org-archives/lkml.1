Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbYDNXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbYDNXGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYDNXGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:06:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45638 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYDNXGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:06:00 -0400
Date: Tue, 15 Apr 2008 00:05:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-mm 11/15] video: Use get/put_unaligned_* helpers
Message-ID: <20080414230557.GD9785@ZenIV.linux.org.uk>
References: <1208213280.11920.41.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208213280.11920.41.camel@brick>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 03:48:00PM -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/video/matrox/matroxfb_misc.c |   28 ++++++++++++++--------------
>  drivers/video/metronomefb.c          |    9 +++------
>  2 files changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/video/matrox/matroxfb_misc.c b/drivers/video/matrox/matroxfb_misc.c
> index ab7fb50..cfb5205 100644
> --- a/drivers/video/matrox/matroxfb_misc.c
> +++ b/drivers/video/matrox/matroxfb_misc.c
> @@ -522,8 +522,6 @@ static void parse_bios(unsigned char __iomem* vbios, struct matrox_bios* bd) {
>  #endif
>  }
>  
> -#define get_u16(x) (le16_to_cpu(get_unaligned((__u16*)(x))))
> -#define get_u32(x) (le32_to_cpu(get_unaligned((__u32*)(x))))

Why not simply change definitions of those?
