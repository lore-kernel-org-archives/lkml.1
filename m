Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYL2IjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYL2IjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 03:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYL2IjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 03:39:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:17114 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYL2IjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 03:39:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZcylXcaKopeqAU7nmMb89QHKOeN/YvghVaqiC5D9xKq87/sMy+5Dbm30dx3+d+E8SC
         VPGt6q8s9IRkP0yeraRYQWcQXxE+bFtnl4fEslJTngDIdO4Q23Z5BaE8UEyZbGZQGDys
         uA1DAGt3iB0iDh+yaK1EVnhifGc4l647wBeh8=
Message-ID: <2f11576a0812290039t11ca9b76sf305e82003ac607@mail.gmail.com>
Date: Mon, 29 Dec 2008 17:39:01 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <86802c440812281601j57fe5ecdif4b63b72280c65cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
	 <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
	 <20081227173839.GA9793@elte.hu>
	 <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
	 <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu>
	 <86802c440812281601j57fe5ecdif4b63b72280c65cd@mail.gmail.com>
X-Google-Sender-Auth: 633010093f711ca5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  kernel/irq/handle.c |    5 -----
>>  kernel/irq/manage.c |    9 +++++++++
>>  2 files changed, 9 insertions(+), 5 deletions(-)
>>
>
> that is not enough.
>
> please check
>
> need one printk, and move two functions into chip.c

I'm sad ;-)

Why you use printk?
if develper use non-x86 machine, they will see perfectly worthless
debug messages...

although something function calling is needed, we can avoid tty output imho.
