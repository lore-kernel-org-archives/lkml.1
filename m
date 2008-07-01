Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbYGAWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbYGAWAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYGAWAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:00:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbYGAWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:00:32 -0400
Date: Tue, 1 Jul 2008 15:00:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add base_hi BAR for oxsemi_840
Message-Id: <20080701150026.d0ee3457.akpm@linux-foundation.org>
In-Reply-To: <20080701234529.67f59f49@kopernikus.site>
References: <20080701234529.67f59f49@kopernikus.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 23:45:29 +0200
Bernhard Walle <bwalle@suse.de> wrote:

> Subject: [PATCH] Add base_hi BAR for oxsemi_840

Please add a subsystem identifier to patch titles.   In this case,

	parport_pc: add base_hi BAR for oxsemi_840

is good.

(IMO this is mainly as a courtesy to people who are browsing the commits
lists) (and short-form changelogs)

> Date: Tue, 1 Jul 2008 23:45:29 +0200
> Organization: SUSE LINUX Products GmbH
> X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
> 
> Use the 2nd BAR for the oxsemi_840 chip as BAR for base_hi.
> Tested with:
> 
> Parallel controller [0701]: Oxford Semiconductor Ltd VScom 011H-EP1 
>         1 port parallel adaptor [1415:8403] (prog-if 03 [IEEE1284])
> 
> This patch is needed to make 'TRISTATE' working with that adaptor.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  drivers/parport/parport_pc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -2877,7 +2877,7 @@ static struct parport_pc_pci {
>  	 * and 840 locks up if you write 1 to bit 2! */
>  	/* oxsemi_952 */		{ 1, { { 0, 1 }, } },
>  	/* oxsemi_954 */		{ 1, { { 0, -1 }, } },
> -	/* oxsemi_840 */		{ 1, { { 0, -1 }, } },
> +	/* oxsemi_840 */		{ 1, { { 0, 1 }, } },
>  	/* aks_0100 */                  { 1, { { 0, -1 }, } },
>  	/* mobility_pp */		{ 1, { { 0, 1 }, } },
>  	/* netmos_9705 */               { 1, { { 0, -1 }, } }, /* untested */

My parport knowledge doesn't permit me to understand how serious the
just-fixed bug was.  Non-functional parport?

If so, this looks like a 2.6.26 and 2.6.25.x fix?

