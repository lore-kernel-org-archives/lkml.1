Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129Ab0AZKIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0AZKIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0AZKIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:08:35 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:40663 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0AZKIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:08:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oCrsW9WJIPhG9COHF7l1XlM0NkyWQHPJ5eBxVF9KW65JgIRZ280bBercbAmQxNOTc5
         otRlO2C5zsLfflT2d4qPwtiyh6kAxVN+hyGkmkHTqefk7ZNLxtkq2B86f0DAZkD4KIya
         PEzsM8SRDmVYhZOA09X+bxUMTGnYvu+HVgMwY=
MIME-Version: 1.0
In-Reply-To: <20100126105640.6bf9488c@marrow.netinsight.se>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
Date: Tue, 26 Jan 2010 18:08:28 +0800
Message-ID: <2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 5:56 PM, Simon Kagstrom
<simon.kagstrom@netinsight.net> wrote:
> For development and testing it's sometimes useful to crash or injure the
> kernel in various ways. This patch adds a debugfs interface to provoke
> null-pointer dereferences, stack corruption, panics, bugons etc. For
> example:
>
>  mount -t debugfs debugfs /mnt
>  echo 1 > /mnt/provoke-crash/null_dereference
>
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> ---
> Obviously this feature is for debugging and testing only, and of
> interest to fairly few people. I've used it for testing the kmsg_dump
> stuff (hence the CC:s above) and kdump, and have found it fairly useful.
>
> If it's not of interest, at least this mail will be in the archives if
> someone else needs something like it :-)
>

Hey, we already have /proc/sysrq-trigger, you need to state why
it is better than using /proc/sysrq-trigger.

Thanks.
