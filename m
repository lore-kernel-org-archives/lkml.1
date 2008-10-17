Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYJQPOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYJQPOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbYJQPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:10:11 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:55837 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbYJQPKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GZa6rPRsYkXCDiGKOXDnq9oWTbdCRb0MqqUm/XmQrRXiWKyJ0ReJ5Ilvac9Jiv0jvz
         3vGBLq2fft6Pm2AEkfLWQrEW+uX+sS5bPmhG5vV6tn1DDEvTcynCMJaoYQuGm4L87pEJ
         CXG42UKCIqbdKow+bmWoFfxYLv6Zp3xWDwzqY=
Message-ID: <b9df5fa10810170810x4d3e385n3a2284dd8b2600df@mail.gmail.com>
Date: Fri, 17 Oct 2008 21:10:07 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "=?ISO-8859-1?Q?Am=E9rico_Wang?=" <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] init: Properly placing noinline keyword.
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081017142610.GA19832@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <b9df5fa10810170605t50e366e9nf62f8a18df37fc3c@mail.gmail.com>
	 <20081017141354.GA9242@x200.localdomain>
	 <b9df5fa10810170717p36dcb4a9y4e74089069dea03c@mail.gmail.com>
	 <20081017142610.GA19832@hack.voiplan.pt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/08, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Oct 17, 2008 at 08:17:33PM +0600, Rakib Mullick wrote:
>  >On 10/17/08, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>  >> On Fri, Oct 17, 2008 at 07:05:32PM +0600, Rakib Mullick wrote:
>  >>  > Here, noinline keyword should be placed between storage class and type.
>  >>
>  >>
>  >> Why?
>  >Because, scripts/checkpatch.pl warned with following warning:
>  >     ERROR: inline keyword should sit between storage class and type
>
>
> Well, 'noinline' is different from 'inline'.
>
>  'noinline' is defined as:
>
>  #define  noinline                       __attribute__((noinline))
>
>  in include/linux/compiler-gcc.h. But 'inline' is a _keyword_ defined
>  by C standard. If checkpatch.pl complains about 'noinline', you should
>  fix checkpatch.pl. :)
Thanks, for explanation. But isn't it nice to place it between storage
class and type ?
>
>
>  --
>  "Sometimes the only way to stay sane is to go a little crazy."
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
