Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYEWMd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYEWMd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYEWMdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:33:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:12450 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbYEWMdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=wfErfyvT/fLEJbj57jsVLXY3Nt2AyVksu5s/A3QPvHszPcVxCQdq/uos4OxuS43kHK3vZDzXfzY81atdCkW5/9VIrL8BYdnWCNx2p++DCSL5PMu8lM6VDkjmBPF+osSI+bj2BhzVWg2vOzvhEM3j1Dm7w5iONj+TxRxaxYS6uVo=
Message-ID: <3877989d0805230533u73c3d09agacf94d80bf99a0bb@mail.gmail.com>
Date: Fri, 23 May 2008 20:33:14 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Petr Tesarik" <ptesarik@suse.cz>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Roland McGrath" <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <1211458368.5610.36.camel@elijah.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_7706_7605130.1211545994533"
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <1211446045.5610.33.camel@elijah.suse.cz>
	 <3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	 <20080522111826.BB90326FA24@magilla.localdomain>
	 <1211458368.5610.36.camel@elijah.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_7706_7605130.1211545994533
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, May 22, 2008 at 8:12 PM, Petr Tesarik <ptesarik@suse.cz> wrote:
> On Thu, 2008-05-22 at 04:18 -0700, Roland McGrath wrote:
>> I really cannot figure out from anything you've said what the failure mode
>> is or how you think it should be affected.
>
> At least you should be able to see the related bug report at:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=446200
>
> I'm getting Access Denied. :(

ok , I just got permit to share the test case here..  Please check out
the attachment.
 1. tar jxvf testpro.tar.bz2
       testpro/test1.c
               test2.sh
2.cd testpro
3.gcc -o test1 test1.c
4.strace -f -o log.txt ./test1

hope you can reproduce the problem.

Thanks,
Luming

------=_Part_7706_7605130.1211545994533
Content-Type: application/x-bzip2; name=testpro.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgkqq5bd0
Content-Disposition: attachment; filename=testpro.tar.bz2

QlpoOTFBWSZTWY3ES1YAAn1/lc6wAIB7d/+PM69+Xv/v3/oAEAABAEAACEACaCkQqEkqbUyExpqZ
MTTammmjIGmgaNMgBiNBppoCRJATTIaTKeU00zU0GhpkaANA0epoaZDIDjI0yYmgyZMJpkDIaA0B
pk0MAJoDHGRpkxNBkyYTTIGQ0BoDTJoYATQGwLvxVKpH/PpicwhNKQJFew/YYeE88xC6WgfFqpiA
iGVCWRpSZCQwYxsGmHv6urtuIhiY1xbeukmU7ocsqgDN35pQEGqjErgm5lBG7zj1l5RijJLfWAtg
jKjXtNtvHLBmLbU4LoMLyGGq6itkhkzr+8VSnsH3N6kz88l/TOG9LQ7ObKYi3JBFJEqJWzrN0QTE
+Dlv2xzaJjxvGcdMiirDTO3dTpmNy0Y0YpsA02Oc+nSs1LND88A1Fbi2OWsSS/YhKoJitWHgF42x
bPLAvVwcJoVn2Vi9ZprVvWZ7LPPLiw12KKRYC70zzk5iiosxSnLZlKdzEQXSVrExlhCkBlSIZP2o
C0ykaiLwzMK6hvQPOLG4y3MaHCc10kmV1dvIKI4Mzgk5H3jJlDL6kyfeS5s/WUo4xmbbzTr4plyc
vsWGTneM8MCsqnggLLIm6RS+0jlK/UULnYYmRgRgmB7V6LJStm6UTmOuIR8eOe/PLkc7DL1XmxVQ
WC3ypWoxl6J3FwUgYMsyVrTrWdHIsHYeTAi2x1CL5bHIa0W9f5VktFhfoDARuLoWPGq22jLmsrkj
aGiL+Akwmo6RoNPggVgVIogOHVciqk2DOlWRA/LKNlat28W4D78ocQVnxghCgXjPpiIESKsNq21A
0JolokRAT1TWfqJJkGokPabgkG2oYqbV/f90V4a6g05xbwXZv5U5cIqVBokTa88CBeBvkCN4QH+L
uSKcKEhG4iWrAA==
------=_Part_7706_7605130.1211545994533--
