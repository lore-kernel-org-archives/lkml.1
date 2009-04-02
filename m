Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZDBL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZDBL5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZDBL5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:57:12 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:34960 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZDBL5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:57:11 -0400
Date: Thu, 2 Apr 2009 13:57:02 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH 15/25] [cris] BUG to BUG_ON changes
Message-ID: <20090402115702.GR31562@axis.com>
References: <1236661850-8237-7-git-send-email-stoyboyker@gmail.com> <1236661850-8237-8-git-send-email-stoyboyker@gmail.com> <1236661850-8237-9-git-send-email-stoyboyker@gmail.com> <1236661850-8237-10-git-send-email-stoyboyker@gmail.com> <1236661850-8237-11-git-send-email-stoyboyker@gmail.com> <1236661850-8237-12-git-send-email-stoyboyker@gmail.com> <1236661850-8237-13-git-send-email-stoyboyker@gmail.com> <1236661850-8237-14-git-send-email-stoyboyker@gmail.com> <1236661850-8237-15-git-send-email-stoyboyker@gmail.com> <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 06:10:40AM +0100, Stoyan Gaydarov wrote:
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  arch/cris/mm/init.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
> index 2fdd212..514f46a 100644
> --- a/arch/cris/mm/init.c
> +++ b/arch/cris/mm/init.c
> @@ -25,8 +25,7 @@ mem_init(void)
>  	int codesize, reservedpages, datasize, initsize;
>  	unsigned long tmp;
>  
> -	if(!mem_map)
> -		BUG();
> +	BUG_ON(!mem_map);
>  
>  	/* max/min_low_pfn was set by setup.c
>  	 * now we just copy it to some other necessary places...
> -- 
> 1.6.1.3

Thanks, adding it to the CRIS tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
