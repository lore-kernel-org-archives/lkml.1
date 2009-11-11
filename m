Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbZKKW1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbZKKW1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbZKKW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:27:13 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61537 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbZKKW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=JUJnZwJK0CNbChJwV/7JwQEgyewAN9P7pD0yGJxtkUmW/O3shkZDpUIjgwlnbNhPYY
         KJQN2Cbwv5C6Ekkgi/GjfZNwYgVMrzCUHTlZBw5oJ324wn+Cgempjwwnihb15X3xgcee
         rBK+dQYLlqW9CM2/4ELcfHfxawhzKSCcb3Cr4=
MIME-Version: 1.0
In-Reply-To: <43e72e890911101527s6d29b35cuaf63e081762c1eb7@mail.gmail.com>
References: <43e72e890911101527s6d29b35cuaf63e081762c1eb7@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 11 Nov 2009 14:26:58 -0800
Message-ID: <43e72e890911111426h3cd1e5bfya3fa6da810ce633e@mail.gmail.com>
Subject: Re: Oops on i915 on 8086:a011 pine trail 2.6.32-rc6
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 3:27 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Getting an oops with a pine trail netbook I'm doing testing on on
> 2.6.32-rc6 with a fresh new distro kernel for the next Ubuntu 10.04
> release:
>
> https://launchpad.net/ubuntu/+source/linux/2.6.32-3.3/+build/1339939/+files/linux-image-2.6.32-3-386_2.6.32-3.3_i386.deb
>
> The machine boots fine with 2.6.31.
>
> The oops happens early on the boot process, I'll next rebuild my own
> with early boot delay (CONFIG_BOOT_PRINTK_DELAY) as that seems to be
> the only way I'm going to get this full trace out. Good thing is its
> 100% reproducible so I should be able to bisect. The only thing
> visible so far is the end of the oops:
>
> http://bombadil.infradead.org/~mcgrof/oops-img/2009/11/2.6.32-rc6-i915-8086-a011-oops-01.jpg

I compiled my own 2.6.32-rc6 based Linus' tip from today actually and
I didn't run into issues.

  Luis
