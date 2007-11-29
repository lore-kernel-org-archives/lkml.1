Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbXK2Mfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbXK2Mfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXK2MfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:35:22 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:36994 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXK2MfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=RuViqgedmHK4gD7j9JPXt/aTFWNi901mfQFbDAxz28b2rS1qO1GxPZbzQIVnX6qilV43HM6syfVPQmphoPf9xFD+u0rwA9H5Z2DPLmKrfgO2wHjwbBDi034oAf5ZnLvQFIpl4Z6AV/15NhzPOLfZ4vA/UT7wJ7V26ov/49NKKIw=
Date: Thu, 29 Nov 2007 20:31:39 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       =?utf-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>
Subject: Re: void* arithmnetic
Message-ID: <20071129123139.GB2458@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071129010531.22b3a71f@werewolf> <Pine.LNX.4.64.0711290130170.22052@fbirervta.pbzchgretzou.qr> <d82e647a0711281719s74035e98pc228ce0da4f3b00d@mail.gmail.com> <474E6C86.8090209@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <474E6C86.8090209@panasas.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 09:38:46AM +0200, Benny Halevy wrote:
>On Nov. 29, 2007, 3:19 +0200, "Ming Lei" <tom.leiming@gmail.com> wrote:
>> 2007/11/29, Jan Engelhardt <jengelh@computergmbh.de>:
>>> On Nov 29 2007 01:05, J.A. Magallón wrote:
>>>> Since begin of the ages the build of the nvidia driver says things like
>>>> this:
>>>>
>>> Explicitly adding -Wpointer-arith to ones own Makefile is like
>>> admitting the code might be problematic. :->
>>>
>>>
>>> I think sizeof(void *) == 1 is taken as granted as sizeof(int) >= 4
>>> these days. Sigh.
>> sizeof(void *) == 4, sizeof(void)==1, :)
>well, sizeof(void *) == sizeof(unsigned long) maybe :)

I *heard* that on Win64 sizeof(void *) > sizeof(long). But it's off-topic
here. ;-)


