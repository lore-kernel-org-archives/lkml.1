Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbZC2Qnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbZC2Qnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZC2QiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:38:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:63829 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbZC2QiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nrwCTOF4yyEIfdgfe9X8Vnv13osvSCNkGNFGUWjb0Ox+4BjeYSMMwmjzTqI/0yiWzn
         MfLY4kEB+0W7oYuJp9uRJ3L3wZkn7x1hBJ5xk7p7DtlUYxJ1HZVppN9wtbD82wah/shH
         EAw8/ia8ma6MChKfyiR+r2uO6UIZW108yLxhM=
Date: Mon, 30 Mar 2009 00:38:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Consolidate init_mm definition
Message-ID: <20090329163857.GF7671@hack>
References: <20090326235116.GA26129@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326235116.GA26129@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 02:51:16AM +0300, Alexey Dobriyan wrote:
>* create mm/init-mm.c, move init_mm there
>* remove INIT_MM, initialize init_mm with C99 initializer
>* unexport init_mm on all arches:
>
>  init_mm is already unexported on x86.
>
>  One strange place is some OMAP driver (drivers/video/omap/) which
>  won't build modular, but it's already wants get_vm_area() export.
>  Somebody should look there.
>

Nice patch!

I don't know if my reply is too late or not.
But, do we need a new C file just to hold the init_mm definition?

Thanks.

-- 
Do what you love, f**k the rest! F**k the regulations!
 
