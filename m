Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYHFPdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYHFPdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbYHFPdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:37583 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbYHFPdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DLFU9XWBQsVWJpZss+riOOcZIUQQgFT/aqUXbesW+7I5NCeAlwdvx1fZ7DkXCG5DA/
         7tN4PyA7auOa42PwONsfBuwvym32SAA2xx4ZEPWAKZK691TPF/Q5c+qz2o4fcU7889n9
         nJ1DBdqN39t6v+v3y7/F9XhqGYLEPLHsEwDzQ=
Message-ID: <b6a2187b0808060833gc9d02caw2893ae8b021d1aa2@mail.gmail.com>
Date: Wed, 6 Aug 2008 23:33:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "David Miller" <davem@davemloft.net>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <b6a2187b0808052342s40a3079fq6c229e3f36faca26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <alpine.LFD.1.10.0808052259070.15995@nehalem.linux-foundation.org>
	 <b6a2187b0808052342s40a3079fq6c229e3f36faca26@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 2:42 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Wed, Aug 6, 2008 at 2:01 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> One trivial thing to try would be to just bisect it. I assume 2.6.26 is
> Bisecting now.

Thanks to all the great helpful suggestions from everyone, and this
turns out that I just need to enable the following switches, so I
didn't bisect further, and since it's first machine that I've tried
with more than 8 CPUs so I wasn't sure whether 2.6.16 has the same
problem, but if you wish, I could give 2.6.16 a try.

> CONFIG_X86_GENERICARCH=y
> CONFIG_X86_BIGSMP=y

Thank you all for the great linux kernel!

Jeff.
