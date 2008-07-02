Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbYGBJKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbYGBJKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYGBJKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:10:05 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:40801 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYGBJKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SaGxuOTKZlyZSkKle1//LG9iMod0pyhwzCm+0VDJiqweU7gxdtXRtPRNHiY39CGNna
         ilKyZV/JbnzyAwrgrnEz2+NdvcojKohR7XUGFbKwHaP7zkcJntE0o6Kuu2Z0UwDE+hUm
         SWKU5DVEUVMdO2ofFBoutM4CONT712pkYco9s=
Message-ID: <a4423d670807020210i706dcf7du5cfb1e35fadb7cd7@mail.gmail.com>
Date: Wed, 2 Jul 2008 13:10:02 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: next-0630: sparc64: build failed
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, sparclinux@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, sagar.abhishek@gmail.com,
       rostedt@goodmis.org
In-Reply-To: <20080701154648.GA31057@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807010825t7ea2eb44oda3f08dc007c40a2@mail.gmail.com>
	 <20080701154648.GA31057@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/1 Ingo Molnar <mingo@elte.hu>:
> thanks Alexander - does the patch below fix it for you?
> commit 760378e1497841246ea7e42abad617d8a8ac0bcc
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Jul 1 17:35:06 2008 +0200
>
>    fix "ftrace: store mcount address in rec->ip"
>

Yes, it fixes the issue. I have tried next-0702 which already includes
your patch.
But it has a name a1d5d08eb4f5c76acd5bb115e13791ce87ec356b.
