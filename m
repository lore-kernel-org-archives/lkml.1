Return-Path: <linux-kernel-owner+w=401wt.eu-S1751120AbZIJEmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbZIJEmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZIJEmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:42:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:5156 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZIJEmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VgBMCadygVqrDsoEhVjfMxACB2/ZFCd4MBwLaEIw1Esu4PmtsnLhxL8n1LMjhO33Gc
         VadoodBmV4c/wn19VB+N3i4Yszlu4BSBzuMPMjMUHQjOpk/H9rX4ACAf/AZm5eInClBF
         Dk/0zifSTbzwQ/C/FLWB3YmjydsXjjbT6lmi8=
MIME-Version: 1.0
In-Reply-To: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
Date: Thu, 10 Sep 2009 12:42:26 +0800
Message-ID: <2375c9f90909092142i58595fedod6780a7c41190f5f@mail.gmail.com>
Subject: Re: [PATCH 0/2] __builtin_unreachable
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 9:59 AM, Roland McGrath <roland@redhat.com> wrote:
> The latest GCC has a better way than "for (;;)" to indicate that a code
> path cannot be reached due to reasons the compiler doesn't understand (such
> as code in an asm).  These patches provide UNREACHABLE() as a macro to hide
> the details of this, and then use it for the BUG() macro on x86, saving
> some dead code otherwise generated.
>
> Other arch's BUG() may want to this too instead of "for (;;)" or __builtin_trap.
>
> There are numerous matches from "git grep -n 'for *(;;) *;'" but it takes
> someone who knows each bit of code to know where that means UNREACHABLE()
> and where it really wants an infinite loop.

Looks good!

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Just curious, what different asm code will gcc generate for this? Comparing it
to for(;;) ? I am sorry that I don't have gcc 4.5 on hand.

Thanks!
