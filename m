Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZKAVN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZKAVN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZKAVN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:13:27 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64178 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbZKAVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ByFxi+ALwErgcOrxqg3F91RK/FJwoWJYIrYConRmT1zLIzlYm/jIhNkD3Fzc2RgfYN
         Oae06FhYAHqOyUEK7oKSQlPoM7DaFXrdL+nv/7GeOibNlbryF9nM4KfO8Ox4m5uB3hD3
         vfopBdjlZCn4clCnWyD+BndL3xWa/0MnyRYNI=
MIME-Version: 1.0
In-Reply-To: <20091101095208.10d57e8f.rdunlap@xenotime.net>
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
	 <4AEC0EBE.2040308@crca.org.au> <4AEC2971.8050105@imap.cc>
	 <20091101095208.10d57e8f.rdunlap@xenotime.net>
Date: Sun, 1 Nov 2009 19:13:30 -0200
Message-ID: <a4c8a6d00911011313k39a6805dr590967cc8fc3a204@mail.gmail.com>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
From: Thiago Farina <tfransosi@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tilman Schmidt <tilman@imap.cc>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 1, 2009 at 3:52 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> It was Robert PJ Day.
> See http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

Talking about cleanup, there are many definitions of ARRAY_SIZE, found
using cscope:
0 spidev_test.c  24 #define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
1 page-types.c  194 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
2 types.h         4 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
3 user.h         17 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
4 boot.h         35 #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
5 relocs.c       13 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
6 kernel.h       46 #define ARRAY_SIZE(arr) (sizeof(arr) /
sizeof((arr)[0]) + __must_be_array(arr))
7 dtc.h          83 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
8 genksyms.c    314 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
9 kallsyms.c     27 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
a file2alias.c  520 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
b util.h         28 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

Please forgive me if this is not the right place to post this.
