Return-Path: <linux-kernel-owner+w=401wt.eu-S971022AbXEIAGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971022AbXEIAGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968382AbXEIAGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:06:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966770AbXEIAGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:06:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=dLmzX/HDlV4mjX3WaDxmpb/uuimWtOB8HM2Rv5mgT3xenOFnzgKyhY7iPa7JtaPwt
	xNEEqFzVnEyeiJCY7U4Jw==
Date: Tue, 8 May 2007 17:06:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
In-Reply-To: <20070508163452.8b71f682.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
 <20070508163452.8b71f682.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add information on the problems with the C-language "volatile" keyword
> and why it should not be used (most of the time).
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/volatile-usage.txt |  129 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 129 insertions(+)
> 
> --- /dev/null
> +++ linux-2.6.21-git10/Documentation/volatile-usage.txt
> @@ -0,0 +1,129 @@
> +***** "volatile" considered useless and evil:  Just Say NO! *****
> +
> +Do not use the C-language "volatile" keyword
> +(extracted from lkml emails from Linus)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +

Again, please change this sweeping introduction to explicitly state that 
Linus' emails were a criticism of using 'volatile' for objects (he refers 
to them as "data structures") and can be appropriate for asm constructs.
