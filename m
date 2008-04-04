Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYDDTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYDDTAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYDDTAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:00:23 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:6539 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYDDTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Gc7ds98Q2EL1WL9NnJ3IdE+CZUjDc/nPW7Se7JDS7h8sbtdGLlPEeR9qofa6L7YM1M/OT8cW7rSoN4H9V8lYf7SJW4+qpreNgvGDZrnXTGhmflkYx3bYw3ejixxaiHX/XQ7TYnZtcaM5Rk2209agEqhNyM2xwpuONbfPhxil8C0=
Subject: Re: [PATCH] Build fix for uml/x86_64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
In-Reply-To: <20080404185147.GB8989@mailshack.com>
References: <20080404184930.GA8978@mailshack.com>
	 <20080404185147.GB8989@mailshack.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 12:00:10 -0700
Message-Id: <1207335610.18838.85.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 20:51 +0200, Alexander van Heukelum wrote:
> Build fix for uml/x86_64, which was broken by:
> x86: remove x86-specific implementations of find_first_bit
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
> 
> Hi Ingo,
> 
> I broke uml again :(
> 
> This patch fixes the problem for x86_64. These changes
> should have been included in:
> 
> x86: switch x86_64 to generic find_first_bit
> 
> Greetings,
>         Alexander
> 
>  arch/um/Kconfig.x86_64      |    4 ++++
>  arch/um/sys-x86_64/Makefile |    2 +-
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
> index a29f545..84cefd5 100644
> --- a/arch/um/Kconfig.x86_64
> +++ b/arch/um/Kconfig.x86_64
> @@ -31,6 +31,10 @@ config SMP_BROKEN
>  	bool
>  	default y
>  
> +config GENERIC_FIND_FIRST_BIT
> +	bool
> +	default y
> +
	def_bool y

Cheers,

Harvey


