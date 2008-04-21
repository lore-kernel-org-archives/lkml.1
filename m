Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbYDUVsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbYDUVsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYDUVsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:48:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:4382 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbYDUVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:47:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BY6DPg3XBEcP0HEu8RFnpK6FPsn6uq8cyizeyn2hCe0ZLztVeh35jC2S52jtbFnz197iVNbnPGaBkNNKnrvj8wS0sX/AuhzY5WaksCBAfMf8OiT3OAEFll/GkVqN8JaYW1NNLrdrk4PBEn3P93ZXhvv7Xsq+khr1xbQZCQSTAFU=
Date: Tue, 22 Apr 2008 02:43:14 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/proc/kmsg.c should #include <linux/proc_fs.h>
Message-ID: <20080421224314.GA963@martell.zuzino.mipt.ru>
References: <20080421213209.GN2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421213209.GN2633@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 12:32:09AM +0300, Adrian Bunk wrote:
> Every file should include the headers containing the externs its global 
> code.

Declaration should be moved to fs/proc/internal.h and included from
there.

> --- a/fs/proc/kmsg.c
> +++ b/fs/proc/kmsg.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/poll.h>
>  #include <linux/fs.h>
> +#include <linux/proc_fs.h>

No, really. Such included tend to stick forever, so let's do right thing
from beginning.

It would be nice if your scripts put at least some names of
relevant globals into changelog.

