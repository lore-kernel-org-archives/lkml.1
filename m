Return-Path: <linux-kernel-owner+w=401wt.eu-S966089AbXDBXHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966089AbXDBXHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966017AbXDBXHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:07:38 -0400
Received: from ozlabs.org ([203.10.76.45]:34667 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966087AbXDBXHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:07:34 -0400
Subject: Re: [PATCH 2/5] Fix race between rmmod and cat /proc/kallsyms
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: pmarques@grupopie.com, linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <20070402150145.GB6735@localhost.sw.ru>
References: <20070402150145.GB6735@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 09:06:58 +1000
Message-Id: <1175555218.12230.449.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 19:01 +0400, Alexey Dobriyan wrote:
> +static inline int module_get_kallsym(unsigned int symnum, unsigned long *value,
> +					char *type, char *name,
> +					char *module_name, int *exported)
>  {
> -	return NULL;
> +	return -ERANGE;
>  }

This would normally by -ENOSYS, but since the return value is used as a
binary anyway, it doesn't matter.

Thanks,
Rusty.


