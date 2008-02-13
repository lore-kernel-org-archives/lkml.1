Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbYBMXIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbYBMXIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbYBMXIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:08:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35162 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbYBMXIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:08:18 -0500
Date: Wed, 13 Feb 2008 15:07:38 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Emelyanov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
 symbols going away
Message-ID: <20080213150738.787435a8@laptopd505.fenrus.org>
In-Reply-To: <1202941327.18204.11.camel@brick>
References: <1202941327.18204.11.camel@brick>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 14:22:06 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  Documentation/feature-removal-schedule.txt         |   10 ------
>  Documentation/feature-removal/exported-symbols.txt |   34
> ++++++++++++++++++++
> arch/x86/kernel/io_delay.c                         |    2 +-
> net/ipv4/inet_hashtables.c                         |    2 +- 4 files
> changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt
> b/Documentation/feature-removal-schedule.txt index 4d3aa51..b09b193
> 100644 --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -118,16 +118,6 @@ Who:    Adrian Bunk <bunk@stusta.de>
>  
>  ---------------------------
>  
> -What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
> -	(temporary transition config option provided until then)
> -	The transition config option will also be removed at the
> same time. -When:	before 2.6.19


3 releases is too long imo
1 release is plenty (esp since it's really 1 release + one devel cycle)
