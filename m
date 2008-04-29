Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbYD2WSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbYD2WSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYD2WSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:18:38 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:29759 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYD2WSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K4iuwSUerHrIhKmTtifs3yRvVHk9CvLXzYMBNXhNcZmclw+tscbWPQ7kk61hwI48sMuKdc2D+jc5/3fMrWv5ulU2EEjCHSS15R8s5ca+GLbDHBt6pmTZnD143C0sgHcMlcmpv4fm6gi4bKPC3sNl7bHtRYJEfLh86IcY8E9NJTk=
Message-ID: <86802c440804291518v58dba61dk656ed74cae207010@mail.gmail.com>
Date: Tue, 29 Apr 2008 15:18:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mika Fischer" <mika.fischer@zoopnet.de>
In-Reply-To: <20080429220953.GI2302@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281244.56938.yhlu.kernel@gmail.com>
	 <200804281316.14168.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <m1wsmg32qk.fsf@frodo.ebiederm.org>
	 <86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com>
	 <m1abjcz9ow.fsf@frodo.ebiederm.org>
	 <86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
	 <20080429220953.GI2302@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 3:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > agreed. so that feature is compiled in but disable by default.
>  >
>  > BTW: is any chance for OS to disable SMI etc? to verify is the
>  > unstatbility is caused by SMI?
>
>  i dont think there's any documented way for that. SMI might be the
>  mechanism that ensures blue-smoke type of system reliability (CPU fan,
>  temperature, etc.) so it would be extremely dangerous to mess with it.

then that is bad and sick HW design.

for example. cpu fan is supposed to full speed, if SW send insane
instruction and lose connection.
also, CPU should shutdown by thermal strip is FAN is stopped.

when we were working on LinuxBIOS, found one MB cpu fan need to be
started by BIOS, and another one is auto full speed if BIOS don't
touch it. We always like the second design.

YH
