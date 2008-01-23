Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYAWQlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYAWQlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYAWQlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:41:36 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:34634 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYAWQlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:41:35 -0500
Date: Wed, 23 Jan 2008 17:40:22 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <bryan.wu@analog.com>,
       Mikael Starvik <mikael.starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] procfs: constify function pointer tables
Message-ID: <20080123164022.GT3912@axis.com>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 09:00:46PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> This touches so many different places that I did not feel like creating 
> a miniscule patch for each architecture. I hope that is ok.
> 
> ===Patch begins===
> [PATCH] procfs: constify function pointer tables
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
...
> diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
> index 65466c4..e42aedd 100644
> --- a/arch/cris/kernel/setup.c
> +++ b/arch/cris/kernel/setup.c
> @@ -180,7 +180,7 @@ static void c_stop(struct seq_file *m, void *v)
>  
>  extern int show_cpuinfo(struct seq_file *m, void *v);
>  
> -struct seq_operations cpuinfo_op = {
> +const struct seq_operations cpuinfo_op = {
>  	.start = c_start,
>  	.next  = c_next,
>  	.stop  = c_stop,

CRIS port:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
