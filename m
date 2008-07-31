Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYGaDvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYGaDvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYGaDvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:51:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:17493 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYGaDvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PxmuErO+Ha0E+vPVKJIDQWYALuu9+GnCwVd3ff74nvmrc1Sh0Xl0wY6K88rd9o1GAe
         0xUUAVuCrI/B3cMr79NWkTNFw0bqiPxyXYqrMo9NtiNpV2F6aEh466ysOP7LMWAgsJ1m
         wBShxg4ZCQ6v1Je3+xu/HhCvxnT1GKUdvKW6c=
Message-ID: <8bd0f97a0807302051u22f49e1fp773cb468494d5fcb@mail.gmail.com>
Date: Wed, 30 Jul 2008 23:51:43 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] blackfin / h8300 build error fix
Cc: "Yoshinori Sato" <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080730203741.4d7df2ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87provuzwk.wl%ysato@users.sourceforge.jp>
	 <8bd0f97a0807300911n4ae81b70v97276abf612f6b3e@mail.gmail.com>
	 <87hca7npmp.wl%ysato@users.sourceforge.jp>
	 <20080730130117.3495cba9.akpm@linux-foundation.org>
	 <8bd0f97a0807302026x41d143b6p5c9eb63ef3185f06@mail.gmail.com>
	 <20080730203741.4d7df2ad.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 11:37 PM, Andrew Morton wrote:
> On Wed, 30 Jul 2008 23:26:47 -0400 "Mike Frysinger" wrote:
>> you cant just use straight symbol names in common header files as they
>> dont take into consideration weird arch-specific ABI conventions.  in
>> the case of Blackfin/h8300, the ABI dictates that any C-visible
>> symbols have an underscore prefixed to them.  thus all symbols in
>> vmlinux.lds.h need to be wrapped in VMLINUX_SYMBOL() so that each arch
>> can put hide this magic in their own files.
>
> ooh, a changelog.
>
> This seems to be a pretty common failing.  I just had to fix the same
> problem in a linux-next patch:

PERCPU is broken in mainline currently as well ... but it looks like
there's extended stuff in linux-next now

> It's going to keep happening too, unless we find some way of making x86
> break when people forget to use VMLINUX_SYMBOL().

i pondered it briefly when i saw Yoshinori's original e-mail, but
nothing pretty came to mind
-mike
