Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167Ab0AEHjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0AEHjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483Ab0AEHjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:39:43 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:47954 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0AEHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cCJpdtUNlTshrOcvrGHAYq3/WEzXRXSUhoRU6mkbzMt1l7jyJekRmFUtWpMkNXUC4/
         c28d2Uuva47TfC5Yk0m/DB7xqYtG/WvgX/MQMGVzG86Xtovw9GZJJq8MZj+c+Tsv4/Wm
         wE+y6U9AFpCzv1jx91asNOvETRCrp7JgOIpTY=
MIME-Version: 1.0
In-Reply-To: <20100104163159.GD23652@elte.hu>
References: <20100104235931.abcf2bc5.sfr@canb.auug.org.au>
	 <20100104163159.GD23652@elte.hu>
Date: Tue, 5 Jan 2010 09:39:40 +0200
X-Google-Sender-Auth: 6ae5f381d3b1a5dc
Message-ID: <84144f021001042339r29f151feja00d7af12a82c9a2@mail.gmail.com>
Subject: Re: linux-next: tip tree build failure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 6:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Hi all,
>>
>> Today's linux-next build (s390x defconfig) failed like this:
>>
>> kernel/panic.c:134: error: 'CALLER_ADDR0' undeclared (first use in this function)
>>
>> Caused by commit eba3fe4416f3cc2ce043fb304b6c35a69dca3bdb ("kernel: Use
>> CALLER_ADDR0 macro").
>
> Thanks - apparently CALLER_ADDR0 isnt generally available. I've reverted this
> patch for now.

Btw, we have _RET_IP_ which is pretty much the same thing and it is
available everywhere (SLUB uses it).
