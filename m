Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbXKKMnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbXKKMnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 07:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXKKMnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 07:43:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:40516 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbXKKMna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 07:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oEc4t6B2z4iNu/k6Q0DHzwH1k2pAkBZVu6UIOved9P52pPrS1V+7/PzRN29tlCEF7Sj9zf70jGi6J2OprgBnWeJIn8GF4KfncTlFV0RZ3u2IwdGyZ4twKeeihW2HE0vH0OWXqHqaHARue/6AISvZyqwYGU3bGvWmeUS+Ibf2Gnw=
Message-ID: <3d8471ca0711110443v46084714m709b2b713a536b19@mail.gmail.com>
Date: Sun, 11 Nov 2007 13:43:28 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Cc: "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071111051408.GC21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071110204038.GA13140@uranus.ravnborg.org>
	 <11947274093185-git-send-email-sam@ravnborg.org>
	 <11947274091127-git-send-email-sam@ravnborg.org>
	 <3d8471ca0711101255m1647e27cm241f358cc49a9921@mail.gmail.com>
	 <20071111051408.GC21669@stusta.de>
X-Google-Sender-Auth: 96f47ebb9b2182cf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On 11/11/07, Adrian Bunk <bunk@kernel.org> wrote:
> What exactly are the use cases where someone would need this?

Glad you asked. Today, when I want to recompile a kernel while
changing a CONFIG_ option, I manually edit the .config,
remove the appropriate line and then run make oldconfig.
I'd like to be able to do: make oldconfig CONFIG_FOO=bar.

Also, when working on a specific feature of the kernel, I tend to
install both a kernel with the CONFIG_ option set and one with
the option unset. Scripts to do that can twiddle the .config file,
but it would be more convenient if kbuild could avoid that.

As you see, I'm more interested in make oldconfig than
make all*config.

Cheers.

-- 
Guillaume
