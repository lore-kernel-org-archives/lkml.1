Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbZEOBLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbZEOBLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZEOBLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:11:00 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:64464 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZEOBK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Huz/q97AN53vCb8jKhM8EmPOLPN++7eHxJE3cUd3wcbUPoeebHrWnSrY8fz5JpGjNo
         AyLF6WRt5LHvFQtmozzA2xp6GTJdsag8kokflj/dDZmAZvm1IdxCK/yxWgV1jLfx6Wsx
         YZPLokK8peUG2WDLL0Z65vm6BeJNjLoLOKw3g=
MIME-Version: 1.0
In-Reply-To: <20090511133949.GA28533@elte.hu>
References: <20090507002133.02D05FC39E@magilla.sf.frob.com>
	 <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com>
	 <20090507083851.GA19133@elte.hu>
	 <20090507085742.GB3036@sequoia.sous-sol.org>
	 <20090507090459.GE19133@elte.hu> <20090507093124.GA355@elte.hu>
	 <20090507094947.GA4911@elte.hu>
	 <20090507125526.c257c23d.akpm@linux-foundation.org>
	 <20090511133949.GA28533@elte.hu>
Date: Fri, 15 May 2009 09:10:58 +0800
Message-ID: <2375c9f90905141810qc7a4c3eg7b800aaf8aac2e7b@mail.gmail.com>
Subject: Re: [patch 1/2] ptrace, security: rename ptrace_may_access => 
	ptrace_access_check
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisw@sous-sol.org,
       oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 9:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> I.e. any function name that can be plain-English answered with:
> 'yes' or 'no' is a red flag for a retval function.
>
> You cannot answer ptrace_access_check() with 'yes' or 'no'. You
> could if it was ptrace_access_ok() or ptrace_may_access.


Aha, then why do you agree with this patch? You don't see
ptrace_access_check() returns bool?? :-)

I stand with Andrew, xxx_check() should not be a boolean function,
ptrace_may_access() looks very OK for me...
