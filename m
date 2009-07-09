Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZGIG15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZGIG15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZGIG1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:27:48 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:52456 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZGIG1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OwmrEGhUi6p5rSOb4JHnm67YpWF9FYj242Id10hqV5uY0PkvrFKdTuezeuevXsRRQO
         xZAUAMfNrNYdp3+Zj65i1E6kgoaNCEKrt1yDtZ32Ig1ExdlahAb9oIHej1YXoMj3Qw/e
         30z302NYyGLAzR201npx742MhgF2sKT3ejPms=
MIME-Version: 1.0
In-Reply-To: <20090709084839G.fujita.tomonori@lab.ntt.co.jp>
References: <1247069178.5973.6.camel@desktop>
	 <1247071445.4159.214.camel@mulgrave.site>
	 <20090708165728.GU23611@kernel.dk>
	 <20090709084839G.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 9 Jul 2009 08:27:45 +0200
Message-ID: <8db1092f0907082327vb3805d3id58dc6cbe71a746c@mail.gmail.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com,
       dwalker@fifo99.com, akpm@linux-foundation.org,
       tarkan.erimer@turknet.net.tr, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/9 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: call blk_scsi_ioctl_init()
>
> Currently, blk_scsi_ioctl_init() is not called so
> blk_default_cmd_filter isn't initalized. Some commands are not blocked
> wrongly.
>
> This fixes a regression introduced:
>
> commit 018e0446890661504783f92388ecce7138c1566d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Jun 26 16:27:10 2009 +0200
>
>    block: get rid of queue-private command filter
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Works with latest git. Thanks for patch

Tested-by Maciej Rutecki <maciej.rutecki@gmail>


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
