Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZBQKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZBQKmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZBQKmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:42:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:45532 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZBQKmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:42:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vipt/8LskEgOb8aufmDuPcZxWO847LRB68J5eP9EuuEJbJwqf6zAoBaaMOC9C6ByvY
         8Yd71OlHp5u+71fBFn1uoLrgzQaP4JlE0lbzMJdA5Arq1PJzLbzrNU0IIiQKa+2rKamM
         JVET7QWxbmp+kdu+YK7rANHE2tZSPT4oKLQ+M=
MIME-Version: 1.0
In-Reply-To: <200902170921.56789.rusty@rustcorp.com.au>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <200902170921.56789.rusty@rustcorp.com.au>
Date: Tue, 17 Feb 2009 11:42:05 +0100
Message-ID: <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 11:51 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hi Andreas,
>
>  This isn't crazy.  But you'd need to benchmark against the minimal
> userspace solution: a binary with all the modules built into
> it which calls sys_init_module on each one, then does the root swizzle
> or whatever.
>
> I think you'd find the difference to be in the noise.

Hi Rusty,

your're right and I'll get right on it.

Cheers,
Andreas

>
> Thanks,
> Rusty.
>
