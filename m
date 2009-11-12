Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbZKLHJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbZKLHJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZKLHJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:09:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:13806 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZKLHJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:09:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=hhL71Xc77slZJL7xlEhkXw/zspgoaP9TMrcZkHSNCC/RfJRoTeMajDDuqE7s3rvKRH
         L1GLdfbzpAHknRK/uXR/ey433IR66H9Kws9zzkQyiWRbmG3J1Elrp4UnLftGWAVWgoH6
         0ehjz6akvSJJnFvca1L8tDJOAT8hp5gWBVWgY=
MIME-Version: 1.0
In-Reply-To: <20091111215928.GA25154@redhat.com>
References: <20091111215928.GA25154@redhat.com>
Date: Thu, 12 Nov 2009 15:09:17 +0800
Message-ID: <2375c9f90911112309xcf76517kb5976cb4b0394102@mail.gmail.com>
Subject: Re: Fix argument order in memset call in ./drivers/media/common/ir-functions.c
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Dave Jones <davej@redhat.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       kraxel@bytesex.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 5:59 AM, Dave Jones <davej@redhat.com> wrote:
> Size is the third argument, not the second.
>
> Signed-off-by: Dave Jones <davej@redhat.com>


Definitely yes.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
> diff --git a/drivers/media/common/ir-functions.c b/drivers/media/common/ir-functions.c
> index 655474b..abd4791 100644
> --- a/drivers/media/common/ir-functions.c
> +++ b/drivers/media/common/ir-functions.c
> @@ -64,7 +64,7 @@ void ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
>
>        ir->ir_type = ir_type;
>
> -       memset(ir->ir_codes, sizeof(ir->ir_codes), 0);
> +       memset(ir->ir_codes, 0, sizeof(ir->ir_codes));
>
>        /*
>         * FIXME: This is a temporary workaround to use the new IR tables
