Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZEMLcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZEMLcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZEMLcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:32:42 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:46644 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZEMLcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A23CPzSOGyfJtQmEoStdweDzbyy5rfs/RUqv3J/HCirmtlpMamocuL0wQjbWgw0AFe
         r4bKQB8GrTGKkbSAhEMsA/TnKxgIbRE2x/OaoSiAVZJzdCUrHsRxYRE96wkXwcVjVKpL
         r/nRsMMcmKTqloN3Td/m7RyrhW24500T9UpYA=
Date: Wed, 13 May 2009 19:33:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: mtk.manpages@gmail.com, tovalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]man-pages : section 9  for kernel api description.
Message-ID: <20090513113357.GA11773@hack>
References: <1242180268.31161.24.camel@centos51>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242180268.31161.24.camel@centos51>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 11:04:28AM +0900, GeunSik Lim wrote:
>
>
>Dear Michael Kerrisk,
>
>Are you maintainer of man-pages(man-pages-3.XX.tar.gz)?
>I am not sure...

Yes, he is.

>
>I use fedora 9 distribution as Linux based Desktop OS currently. 
>I have one proposal about "#> man <linux-kernel-api>" command.
>Can you tell me your opinion about below patch?
>Thanks reading. 
>
>commit 45e950c98412c002c47254507a199731315c7c2b
>Author: GeunSik,Lim <leemgs1@gmail.com>
>Date:   Wed May 13 10:49:47 2009 +0900
>
>    Append Section 9 info of man command.
>    
>    We view description of the Linux kernel API with man command.
>       For example,
>       Fedoar9#> yum install kernel-doc*
>       Fedora9#> man kobject_rename  or
>       Fedora9#> man kthread_create

Why?
Why do you want kernel api doc be in man pages?
Why not just browsing the kernel source code?

Kernel APIs are not stable at all, this is also a reason why you
should not include their doc into man pages.

-- 
Live like a child, think like the god.
 
