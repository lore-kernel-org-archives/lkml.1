Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYHOGd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYHOGd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 02:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYHOGdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 02:33:49 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:63262 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYHOGds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 02:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J62WhXaZ/R6Md1bwE4y1OA9JFVMNr7VK+UFZDXhoSeKW6QGtwR0danYY3Mn/HieX2b
         2Obo7LVIwI8oMl4XgQ/kMdJBgfl5V23/1J5v847TTa5jGD0j0CwliYWKSEGrkMbMC+Ex
         l7wLL55tWnam7eh2iZKGoPOwADSR+PWclClrc=
Message-ID: <19f34abd0808142333t71ed91a2w9e4f16b8c4e1ee5b@mail.gmail.com>
Date: Fri, 15 Aug 2008 08:33:47 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH -tip] x86_64: uml: fix rename header guard
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Jeff Dike" <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48A4CD01.9080805@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A4CD01.9080805@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 2:25 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> In unistd_64.h, the guard macro _ASM_X86_64_UNISTD_H_ is renamed to
> ASM_X86__UNISTD_64_H.
>
> This change should be applied to arch/um/sys-x86_64/syscall_table.c.
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

I guess I screwed up again. Forgot to look for #undefs :-(

Thanks, and acked.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
