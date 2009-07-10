Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbZGJAqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbZGJAqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZGJAqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:46:25 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:44065 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZGJAqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=W3uYvcMF3+5iccRa4oCqqRsT6RoBlpbTKcWGN2+IuOcMWyi106BTBJw3MDSgynIA3T
         aK12Ws+mxeBGghLFzlMJ8jkyf0FAoLM0zpzjQxIxqKXp8RpfCXLbnuXOR/IevQZmBHNJ
         xK3n2G8DhTLDkSEaPl1FdjomUGN46OBH3NG6w=
Subject: Re: What's happening with vr41xx_giu.c?
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Shinya Kuribayashi <shinya.kuribayashi@necel.com>
Cc: yuasa@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A5680B5.2090405@necel.com>
References: <4A5680B5.2090405@necel.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 10 Jul 2009 08:46:11 +0800
Message-Id: <1247186771.5607.2.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same to me.

is there a bug in git?

On Fri, 2009-07-10 at 08:43 +0900, Shinya Kuribayashi wrote:
> Does anyone have a similar symptom?
> 
> ---
> skuribay@ubuntu:linux.git$ git checkout -f master
> Already on 'master'
> skuribay@ubuntu:linux.git$
> skuribay@ubuntu:linux.git$ git log HEAD^..
> commit 4eebdebd71325d0814b1c8e093fd0d1f191da9aa
> Author: Kurt Martin <kurt@mips.com>
> Date:   Wed Jul 8 19:22:35 2009 -0700
> 
>     MIPS: SMTC: Move cross VPE writes to after a TC is assigned to VPE.
> 
>     Signed-off-by: Chris Dearman <chris@mips.com>
>     Signed-off-by: Raghu Gandham <raghu@mips.com>
>     Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> skuribay@ubuntu:linux.git$
> skuribay@ubuntu:linux.git$ git status
> # On branch master
> nothing to commit (working directory clean)
> skuribay@ubuntu:linux.git$
> skuribay@ubuntu:linux.git$
> skuribay@ubuntu:linux.git$ make distclean
> skuribay@ubuntu:linux.git$
> skuribay@ubuntu:linux.git$
> skuribay@ubuntu:linux.git$ git status
> # On branch master
> # Changed but not updated:
> #   (use "git add/rm <file>..." to update what will be committed)
> #   (use "git checkout -- <file>..." to discard changes in working directory)
> #
> #       deleted:    drivers/char/vr41xx_giu.c
> #
> no changes added to commit (use "git add" and/or "git commit -a")
> skuribay@ubuntu:linux.git$
> 

