Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbYJ2CMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbYJ2CMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 22:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYJ2CLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 22:11:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:46605 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYJ2CLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 22:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wT+NDv+kND6Vnbmhg01F12clcL2ysJpV9WN4w60OO7BEpZOr6aQeKqghe4KYvrYmRm
         U+TPNsuvXbvAiXdmlJ29G5O7cbyNs/pPuvPnFNRP8jQanfBdBR3GWY0AHjn7W5+R/j9s
         UXILQPvkVwa6Hf3zN9EcojJYTN4aPog5MIFhg=
Date: Wed, 29 Oct 2008 05:15:05 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: [PATCH V2 14/16] Squashfs: Kconfig entry
Message-ID: <20081029021505.GA977@x200.localdomain>
References: <E1Kv0C4-0006Hm-Jz@dylan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kv0C4-0006Hm-Jz@dylan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 01:49:56AM +0000, Phillip Lougher wrote:
>  fs/Kconfig |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++

> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -931,6 +931,58 @@ config CRAMFS
>  
>  	  If unsure, say N.
>  
> +config SQUASHFS

No, no, no. Add fs/squashfs/Kconfig and source it from fs/Kconfig.
