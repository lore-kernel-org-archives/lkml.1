Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYC1MXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYC1MXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYC1MXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:23:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44265 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYC1MXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:23:42 -0400
Date: Fri, 28 Mar 2008 13:23:54 +0100
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: dsd@gentoo.org, randy.dunlap@oracle.com, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in
 Documentation/unaligned-memory-access.txt
Message-ID: <20080328132354.2a3b766e@bull.net>
In-Reply-To: <1206699042-1334-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1206699042-1334-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Dmitri,

  one more typo I guess:

On Fri, 28 Mar 2008 13:10:42 +0300 Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> This patch deletes a couple of superfluous word occurrences in the
> document Documentation/unaligned-memory-access.txt.
> ---
> Sorry for a duplicate email, I forgot to Cc LKML when sending the patch.
> 
>  Documentation/unaligned-memory-access.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/unaligned-memory-access.txt b/Documentation/unaligned-memory-access.txt
> index 6223eac..ed57b53 100644
> --- a/Documentation/unaligned-memory-access.txt
> +++ b/Documentation/unaligned-memory-access.txt
> @@ -57,7 +57,7 @@ here; a summary of the common scenarios is presented below:
>     unaligned access to be corrected.
>   - Some architectures are not capable of unaligned memory access, but will
>     silently perform a different memory access to the one that was requested,
> -   resulting a a subtle code bug that is hard to detect!
> +   resulting a subtle code bug that is hard to detect!
                ^
               in a

  Sebastien.

>  
>  It should be obvious from the above that if your code causes unaligned
>  memory accesses to happen, your code will not work correctly on certain
> @@ -209,7 +209,7 @@ memory and you wish to avoid unaligned access, its usage is as follows:
>  
>  	u32 value = get_unaligned((u32 *) data);
>  
> -These macros work work for memory accesses of any length (not just 32 bits as
> +These macros work for memory accesses of any length (not just 32 bits as
>  in the examples above). Be aware that when compared to standard access of
>  aligned memory, using these macros to access unaligned memory can be costly in
>  terms of performance.
