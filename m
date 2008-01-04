Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYADPDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYADPDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYADPDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:03:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:54953 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYADPDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=TWQZ49tx0KigpM6lIWd7mKgsFNbo5tL4u2tEg/CijYnuE/EDCwVCkr5pOugtNZtGm01Hyz6O2tQUiak2qWETUgKWfwrXF0r9pauAcKPYdSUNSfpEsweB6YACxGpmrztT9dhzxMvLw97WgXb/MZtlCFDvH1Nqns/qESm4pU+zqNI=
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: reboot_{32|64}.c unification
Date: Fri, 4 Jan 2008 16:03:10 +0100
User-Agent: KMail/1.9.7
Cc: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <200801040110.23817.mboton@gmail.com> <20080104130331.GB20981@elte.hu>
In-Reply-To: <20080104130331.GB20981@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801041603.11178.mboton@gmail.com>
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 14:03:31 Ingo Molnar wrote:
> * Miguel Botón <mboton.lkml@gmail.com> wrote:
> > reboot_{32|64}.c unification patch.
> >
> > This patch unifies the code from the reboot_32.c and reboot_64.c
> > files.
> >
> > It has been tested in computers with X86_32 and X86_64 kernels and it
> > looks like all reboot modes work fine (EFI restart system hasn't been
> > tested yet).
>
> thanks, applied.
>
> > Probably I made some mistakes (like I usually do) so I hope we can
> > identify and fix them soon.
>
> well you sent it via Kmail, which is notorious for not wanting to send
> proper plain-text patches. Yours was:
>
>  Content-Type: text/plain;
>    charset="utf-8"
>  Content-Transfer-Encoding: quoted-printable
>  Content-Disposition: inline
>
> so i had to hand-apply it. There's a Kmail section in
> Documentation/email-clients.txt, please read it.
>
> 	Ingo

Yep, I used Kmail. Thanks for the warning.

-- 
	Miguel Botón
