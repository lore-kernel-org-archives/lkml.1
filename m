Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbXESSRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbXESSRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbXESSRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:17:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:44785 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbXESSRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YJ8tzmcBFyRL0Phl3R+j8H+/hq7uEfe/9mejzjU7sHYK8tRjtxxOk3hE3XsFuzee2N96oymzOnifI/fPemW5w/47vEYtRMIGzRI9iksuhxD9c1UzGJ6ossx9b8PWhOFVAtatN6uJS5TYAauNir54N5iNlB4O+nIfHECj6ySKXAc=
Message-ID: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com>
Date: Sat, 19 May 2007 20:17:35 +0200
From: "oliver pinter" <oliver.pntr@gmail.com>
To: "Bernd Eckenfels" <ecki@lina.inka.de>
Subject: Re: it seems at XFS bug?!
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com
In-Reply-To: <E1HpTQX-0001hN-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40705191046t29cdad68oe4e613b6c71deb93@mail.gmail.com>
	 <E1HpTQX-0001hN-00@calista.eckenfels.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Bernd Eckenfels <ecki@lina.inka.de> wrote:
> In article <6101e8c40705191046t29cdad68oe4e613b6c71deb93@mail.gmail.com> you wrote:
> > -rw-r--r-- 1 root root      0 2007-05-06 12:41
> >
> > the last line is very interesting, this file has no name and the size is 0 byte.
>
> Well, 0 byte files are nothing special, and the name: it might be a non-printable char?
>
> > touch ' '
>
> will produce a similiar file. Try "ls -li | od -cx"
>

0000000   t   o   t   a   l       4   6   0  \n   8   6   1   2   5   5
        6f74 6174 206c 3634 0a30 3638 3231 3535
0000020   4       -   r   w   x   r   -   x   r   -   x       1       r
        2034 722d 7877 2d72 7278 782d 3120 7220
0000040   o   o   t       r   o   o   t                   2   5   9
        6f6f 2074 6f72 746f 2020 2020 3532 2039
0000060   2   0   0   7   -   0   5   -   0   6       1   3   :   1   4
        3032 3730 302d 2d35 3630 3120 3a33 3431
0000100       l   s   p   c   .   s   h  \n   8   6   1   2   5   5   2
        6c20 7073 2e63 6873 380a 3136 3532 3235
0000120       -   r   w   -   r   -   -   r   -   -       1       r   o
        2d20 7772 722d 2d2d 2d72 202d 2031 6f72
0000140   o   t       r   o   o   t           9   2   1   8   4       2
        746f 7220 6f6f 2074 3920 3132 3438 3220
0000160   0   0   7   -   0   5   -   0   6       1   3   :   0   6
        3030 2d37 3530 302d 2036 3331 303a 2036
0000200   m   y   p   c   .   t   x   t  \n   8   6   1   2   5   5   1
        796d 6370 742e 7478 380a 3136 3532 3135
0000220       -   r   w   -   r   -   -   r   -   -       1       r   o
        2d20 7772 722d 2d2d 2d72 202d 2031 6f72
0000240   o   t       r   o   o   t           9   1   0   5   8       2
        746f 7220 6f6f 2074 3920 3031 3835 3220
0000260   0   0   7   -   0   5   -   0   6       1   2   :   4   2
        3030 2d37 3530 302d 2036 3231 343a 2032
0000300   p   c   .   t   c   t  \n   8   6   1   2   5   4   8       -
        6370 742e 7463 380a 3136 3532 3834 2d20
0000320   r   w   -   r   -   -   r   -   -       1       r   o   o   t
        7772 722d 2d2d 2d72 202d 2031 6f72 746f
0000340       r   o   o   t           9   3   8   3   4       2   0   0
        7220 6f6f 2074 3920 3833 3433 3220 3030
0000360   7   -   0   5   -   0   6       1   2   :   5   8       p   c
        2d37 3530 302d 2036 3231 353a 2038 6370
0000400   .   t   x   t  \n   8   6   1   2   5   5   0       -   r   w
        742e 7478 380a 3136 3532 3035 2d20 7772
0000420   -   r   -   -   r   -   -       1       r   o   o   t       r
        722d 2d2d 2d72 202d 2031 6f72 746f 7220
0000440   o   o   t       1   8   2   1   1   6       2   0   0   7   -
        6f6f 2074 3831 3132 3631 3220 3030 2d37
0000460   0   5   -   0   6       1   2   :   3   9       t   e   t  \n
        3530 302d 2036 3231 333a 2039 6574 0a74
0000500   8   6   1   2   5   4   9       -   r   w   -   r   -   -   r
        3638 3231 3435 2039 722d 2d77 2d72 722d
0000520   -   -       1       r   o   o   t       r   o   o   t
        2d2d 3120 7220 6f6f 2074 6f72 746f 2020
0000540                   0       2   0   0   7   -   0   5   -   0   6
        2020 2020 2030 3032 3730 302d 2d35 3630
0000560       1   2   :   4   1          \n  \0
        3120 3a32 3134 a020 000a
0000571
