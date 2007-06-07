Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXFGJhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXFGJhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXFGJg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:36:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:6153 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXFGJg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LcoRPHkDDoH5UOmsLH/TTMKiAIDcCT4+WClOf1uXz9IC4vvk+gu9kgt7An4ibdyEdlyP7boeFcvCVti8j7Ftcj9Sn9DWVW4mp73Znwg0Y6pMQuNIM7OUN8+AkrlHB2FgT7HLCXKek3VL0w8I+YjY4++I9UDq627TcNxPRlysgpM=
Message-ID: <9a8748490706070236ob529fedn2ea1d9797e575976@mail.gmail.com>
Date: Thu, 7 Jun 2007 11:36:57 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Mike Frysinger" <vapier@gentoo.org>
Subject: Re: [patch/rfc] implement memmem() locally in kallsyms.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706070116.32042.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706070116.32042.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/07, Mike Frysinger <vapier@gentoo.org> wrote:
> This patch basically copies the gnulib version of memmem() into
> scripts/kallsyms.c.  While a useful function, it isn't in POSIX so some
> systems (like Darwin) choose to omit it.  How do others feel ?
>

Do people actually build Linux kernels on Darwin & *BSD systems? If
they do then why?

What I'm getting at is; why do we care if it will build there?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
