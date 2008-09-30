Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYI3XIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYI3XIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYI3XIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:08:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:42699 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYI3XIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Km7HB6Yuah/yKN4sW4oMJqT1BvPG8tXiyrduITqIKOtY0ALxL2m5ZutnZW5o/YN1pO
         RBKxEdXTU6VKvh2ewqrdickupfGieYh+I5JY1pPohblmMZGzeZhwXHaLEomqU8KeJNgz
         n75VqmhxouNeb9Wyq3ehiPd386xWu5BnwtqE8=
Message-ID: <86802c440809301608q8551b8as8eeadb6cee49f6a4@mail.gmail.com>
Date: Tue, 30 Sep 2008 16:08:37 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: remove noop cpus_and() with CPU_MASK_ALL.
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200810010859.52259.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810010859.52259.rusty@rustcorp.com.au>
X-Google-Sender-Auth: f4368a0241c411ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 3:59 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> I'm not sure what this is supposed to do.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff -r 52e0cb95ef98 arch/x86/kernel/io_apic_32.c
> --- a/arch/x86/kernel/io_apic_32.c      Sat Sep 06 15:18:06 2008 +1000
> +++ b/arch/x86/kernel/io_apic_32.c      Thu Sep 18 14:30:01 2008 +1000

can you check tip/master?

http://people.redhat.com/mingo/tip.git/readme.txt

we merged io_apic_32.c and io_apic_64.c to io_apic.c for 2.6.28
also make 32bit to use per-cpu vector....

YH
