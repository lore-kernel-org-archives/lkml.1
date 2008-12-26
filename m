Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYLZEhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYLZEhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 23:37:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYLZEgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 23:36:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:44277 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYLZEgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 23:36:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NaYXmtvx/3JG+bWg9HH+n4aVfcClS1tL0bB3hT1Yz61zZtNak9ZldUnpzyhqDncH/i
         2xOaxL/V733G00usud4TNRt9amprbhtgNTEa5klDTZ4Tji+DuhZ86G8jRRdX8yDrNNqJ
         kSKtHj8HlZo1El4MZQYgTuovxkTFLaOub7UF8=
Message-ID: <86802c440812252036h37d4886bucab9ff3591f94821@mail.gmail.com>
Date: Thu, 25 Dec 2008 20:36:52 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH for -tip 3/4] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081226131855.5CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081226122422.5CAC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <86802c440812252018w3919614fwaf591aa1e93d2085@mail.gmail.com>
	 <20081226131855.5CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: c58432ef9f138db7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 8:21 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
>> > Impact: cleanup
>> >
>> > introduce irq_inuse() macro and remove ifdef in stat.c
>>
>> should have a good name... irq_inuse is some confusing.
>
> Why?
> May I ask your perfered name?

after freeing msi with dynamic_irq_cleanup(), that irq_desc is not used.

YH
