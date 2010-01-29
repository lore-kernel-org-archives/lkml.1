Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190Ab0A2Nbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0A2Nbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 08:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126Ab0A2Nbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 08:31:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:50194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab0A2Nbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 08:31:32 -0500
Message-ID: <4B62E335.8010207@suse.cz>
Date: Fri, 29 Jan 2010 14:31:33 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] markup_oops.pl: fix get "No matching code found" when
  first line of range is the faulting instruction
References: <4B61357A.5080001@windriver.com> <20100128181240.GA9174@merkur.ravnborg.org> 	<daef60381001282003q4d43c01dk91c53ec5be17fdf2@mail.gmail.com> 	<1264739206.10856.8.camel@Joe-Laptop.home> <daef60381001282145q39f6fcd8s340e1d74f2466426@mail.gmail.com>
In-Reply-To: <daef60381001282145q39f6fcd8s340e1d74f2466426@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hui Zhu napsal(a):
> What about this?
> 
> Signed-off-by: Hui Zhu <teawater@gmail.com>
> 
> ---
>  MAINTAINERS |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3095,6 +3095,8 @@ S:	Maintained
>  F:	Documentation/kbuild/
>  F:	Makefile
>  F:	scripts/Makefile.*
> +F:	scripts/markup_oops.pl
> +F:	scripts/mk*
> 
>  KERNEL JANITORS
>  L:	kernel-janitors@vger.kernel.org

(somehow I was un-CCed again)

I don't know if we really need to mention every single script that has
no "real" maintainer in the kbuild section. As noted by Joe, adding
scripts/* is also not a good idea. scripts/get_maintainer.pl parses
Signed-off-by: lines, so after the first commit, my email should appear
in the output anyway. For people reading the MAINTAINERS file
themselves, what about this one?

Subject: [PATCH] MAINTAINERS: add a few more patterns to kbuild

Also, add a note that "unmaintained" files below scripts/ should go via
the kbuild tree (best current practice).

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/MAINTAINERS b/MAINTAINERS
index c8f47bf..f0c3e2f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3088,7 +3088,7 @@ L:        autofs@linux.kernel.org
 S:     Maintained
 F:     fs/autofs4/

-KERNEL BUILD
+KERNEL BUILD + files below scripts/ (unless maintained elsewhere)
 M:     Michal Marek <mmarek@suse.cz>
 T:     git git://repo.or.cz/linux-kbuild.git for-next
 T:     git git://repo.or.cz/linux-kbuild.git for-linus
@@ -3097,6 +3097,9 @@ S:        Maintained
 F:     Documentation/kbuild/
 F:     Makefile
 F:     scripts/Makefile.*
+F:     scripts/basic/
+F:     scripts/mk*
+F:     scripts/package/

 KERNEL JANITORS
 L:     kernel-janitors@vger.kernel.org

