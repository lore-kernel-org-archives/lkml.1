Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYLaIlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYLaIlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYLaIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:40:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:55897 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYLaIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:40:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HVbd0fWMl9IpZczg63w580sXOq5ukwB9DZROs+/bRXC06x75J0VVHssyzzQd9KbiBC
         9LfMbbNHN50UUhfMFCs5b4NV3agsz3A03AyWRSiyOJx30gtyi9JZWgw4sWLrXJWqGqRJ
         2XjOdDwcBWZU/FHsiQE0z1zXWnPJBQmxOusjI=
Message-ID: <3f9a31f40812310040y27c39b87v456ae38e46031624@mail.gmail.com>
Date: Wed, 31 Dec 2008 14:10:57 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] fix compilation error
Cc: "Frederic Weisbecker" <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081231081458.GB12942@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230648007.10677.1.camel@jaswinder.satnam>
	 <20081230205230.GA6151@nowhere> <495AA87D.9060704@kernel.org>
	 <495ABDF8.2070703@kernel.org> <20081231004722.GA28472@nowhere>
	 <495AC45D.8010102@kernel.org> <20081231014747.GB28472@nowhere>
	 <20081231081458.GB12942@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Wed, Dec 31, 2008 at 1:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Could you check whether latest tip/master is still OK? I had these
> problems resolved locally (but forgot to push them out), and now i also
> had to do a few conflict resolutions with latest -git, hopefully i have
> not lost hpa's fixes ...
>

With latest/tip, I am still getting error on X86_32 machines :

  CC      mm/slab.o
mm/slab.c:105:31: error: tracing/kmemtrace.h: No such file or directory
make[1]: *** [mm/slab.o] Error 1
make: *** [mm] Error 2

Thank you,
JSR
