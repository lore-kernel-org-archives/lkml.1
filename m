Return-Path: <linux-kernel-owner+w=401wt.eu-S1764913AbYBNTh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764913AbYBNTh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbYBNThP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:37:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49579 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbYBNThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:37:14 -0500
Date: Thu, 14 Feb 2008 11:36:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel-doc: remove fastcall
Message-Id: <20080214113625.5a5d77d2.randy.dunlap@oracle.com>
In-Reply-To: <1203017437.2748.73.camel@brick>
References: <1203017437.2748.73.camel@brick>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 11:30:37 -0800 Harvey Harrison wrote:

> fastcall is gone from the tree, no need to adjust the function
> prototypes anymore for this.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  scripts/kernel-doc |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 6c18a14..26146cb 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1624,7 +1624,6 @@ sub dump_function($$) {
>  
>      $prototype =~ s/^static +//;
>      $prototype =~ s/^extern +//;
> -    $prototype =~ s/^fastcall +//;
>      $prototype =~ s/^asmlinkage +//;
>      $prototype =~ s/^inline +//;
>      $prototype =~ s/^__inline__ +//;
> -- 

---
~Randy
