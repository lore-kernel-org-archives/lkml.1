Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYGDOyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYGDOyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYGDOxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:53:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:65197 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbYGDOxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f16/IgCY/foWvznS+WfL8y2FhAUr6I/9TPlJGCEkY+MMvfHIpd+BsTndQmd6lKWqof
         NQ6g0rbUSH0QPyEaYU55azXxgIg1W7U/Ydu52dg1jDhEYQ10mBH+fmg0b/kEl5TyJ5gK
         ZDdk9TSgDh96XzcD/CCRUYnSfJQJ3C3qx6JAM=
Message-ID: <a4423d670807040753u21b01f7au8f5c1d89d8281c19@mail.gmail.com>
Date: Fri, 4 Jul 2008 18:53:49 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: next-0704: x86_64 panics on booting
Cc: linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
In-Reply-To: <20080704142409.GA18824@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807040720o3e8e350ds5c13dfca8e8adc58@mail.gmail.com>
	 <20080704142409.GA18824@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/4 Ingo Molnar <mingo@elte.hu>:
> does the patch below fix it?
>
>        Ingo
>
> -------------->
> commit 181b3601a1a7d2ac3ace6b23cb3204450a4f9a27
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Sun Jun 29 20:02:44 2008 -0700
>
>    x86: setup_arch() && early_ioremap_init()

Yes, thanks!
