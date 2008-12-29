Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYL2AGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYL2AGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYL2AGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:06:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:49462 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYL2AGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SbGAqDJ46A3zKIby7ItFlc2SC3UmNo55CHlyTTAr9cMJkd5dkghAhzxYOij+7FsNVI
         hHfnIq1H1Sl9qR0m7Yab6cqpLsnO+kG8x+1bTgkFphjN4eN8yhOyGeyrO+EDU5CHV/05
         nx0zksrvUkfPcuEgY5toDKBI8e/Z2Pr4JBjYM=
Message-ID: <86802c440812281606o6e8fbde1ub2e5055f83fea47@mail.gmail.com>
Date: Sun, 28 Dec 2008 16:06:09 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <4958120F.4060804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
	 <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
	 <20081227173839.GA9793@elte.hu>
	 <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
	 <20081228232729.GA2158@elte.hu> <4958120F.4060804@zytor.com>
X-Google-Sender-Auth: 270596737dc4de92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 3:55 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
>>
>> ok, agreed. I was hoping for some more generic workaround but nothing
>> seemed to keep gcc from inlining such functions.
>>
>
> Other than blacklisting those gcc versions.  It's pretty easy to
> understand how a bug like that could creep in, since one of the main
> improvements of the early gcc4 series was better inlining as an
> optimization.

1. one time path add one dummy printk
2. multi path, could move it to another file.
could add one like kernel/weak.c to collect those ...

>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.

good to know.

YH
