Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZLNT5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZLNT5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbZLNT5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:57:47 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:36293 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbZLNT5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:57:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ao2i5S7Eja90THU68z/BkNXI3pcDYOfBjpDmCX4Z+SUB5erk94Qt8M8Tw9XJTrKmjQ
         EqTKawQlxLRBTfjnTqgo5y1MoEF/v/aX7S5otcE+fBFy8s4+/8jS1qjR4ds1dDQzYpmN
         Pz1yXPPTI8DubLd+Spsaxk5jGlmUYEhgIqSsY=
MIME-Version: 1.0
In-Reply-To: <20091214.110905.207084342.davem@davemloft.net>
References: <20091213.182502.215092085.davem@davemloft.net> 
	<1260781359.4165.42.camel@twins> <20091214.110905.207084342.davem@davemloft.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Dec 2009 14:57:25 -0500
Message-ID: <8bd0f97a0912141157w42d02da9y6aaaf64f8bcae454@mail.gmail.com>
Subject: Re: cpu_clock() in NMIs
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 14:09, David Miller wrote:
> 12) Blackfin, TS version is same as sparc64
>
>    non-TS version is unnecessary duplication of generic weak
>    function version in kernel/sched_clock.c and could be deleted

thanks, i'll take care of this
-mike
