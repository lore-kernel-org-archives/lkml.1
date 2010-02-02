Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0BBF6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 00:58:45 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37694 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0BBF6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 00:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nvZExYCsJ7wvIqQMRFUoVbmjMVApH4fo9QEajJwWfumjwlWLZFwbFLnrXVWC4q/6Df
         u81a7zDW/z1rGO2rtcLQEj8g2drEMEGtBuGLg5wEAt7JOQ/TWvY+YrP6GMtxuaWNAoXu
         acuBejBiqgCVbRpnDECa5L2TfEx0fsZHrZfoA=
Subject: Re: [PATCH] mtdchar.c: fix different address space noise
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       dwmw2@infradead.org
In-Reply-To: <201001151125.39100.hartleys@visionengravers.com>
References: <201001151125.39100.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 07:58:39 +0200
Message-Id: <1265090319.2517.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 11:25 -0700, H Hartley Sweeten wrote:
> mtdchar.c: fix different address space noise
> 
> In mtd_ioctl MEMGETREGIONINFO the region_user_info pointer ur
> is cast in __kernel space. This produces a number of sparse warnings
> like:
> 
> warning: cast removes address space of expression
> warning: incorrect type in initializer (different address spaces)
>    expected unsigned int const [noderef] <asn:1>*register __p
>    got unsigned int *<noident>
> 
> Since argp is already a void __user * just use it dirrectly without
> the cast and make ur a __user *.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>

Pushed this one to my l2-mtd-2.6 / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

