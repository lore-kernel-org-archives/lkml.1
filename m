Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbXKKPAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbXKKPAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXKKO75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:59:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:2209 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbXKKO74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QpWOQtUgHFPW+FgF7CCUNq5LFQx9U7uEtlFKZuLjJGbXx10t37UvgsPfY83i12NObKGAsnepcdqIgyIyhHF/wMT8NmpwN6Y7HHJoQR0VS1CfQDHv30B1UCTJwI+cscdkFYzAXhGwFMPZPdhd1+04T0Zp/qv6Nt+UJ81hYwWraO8=
Message-ID: <3d8471ca0711110659w20b6dd8epfa49cd3fcb814d0e@mail.gmail.com>
Date: Sun, 11 Nov 2007 15:59:54 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Cc: "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071111130714.GN21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071110204038.GA13140@uranus.ravnborg.org>
	 <11947274093185-git-send-email-sam@ravnborg.org>
	 <11947274091127-git-send-email-sam@ravnborg.org>
	 <3d8471ca0711101255m1647e27cm241f358cc49a9921@mail.gmail.com>
	 <20071111051408.GC21669@stusta.de>
	 <3d8471ca0711110443v46084714m709b2b713a536b19@mail.gmail.com>
	 <20071111130714.GN21669@stusta.de>
X-Google-Sender-Auth: 429a48b7df851ca4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/07, Adrian Bunk <bunk@kernel.org> wrote:
> Another important point is that users that know about and see CONFIG_*
> variables are kernel hackers, not the normal kconfig users.

But kconfig is mainly for kernel hackers, otherwise it would be
called CML2 ;-)

> > Also, when working on a specific feature of the kernel, I tend to
> > install both a kernel with the CONFIG_ option set and one with
> > the option unset. Scripts to do that can twiddle the .config file,
> > but it would be more convenient if kbuild could avoid that.
>
> I'm wondering why you don't use two different O= output directories
> instead?
>
> Depending on the CONFIG_ option in question this might even greatly
> reduce your compile times.

/me is filled with wonder at the discovery that .config is saved in the O=
directory. Thanks a lot Adrian for this time saver. So it's not strictly an
output directory, more a build directory.

I still think "make oldconfig CONFIG_FOO=bar" is useful for the occasional
config change, but thanks again for this great tip.

-- 
Guillaume
