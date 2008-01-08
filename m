Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYAHKY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYAHKY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYAHKYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:24:19 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:10353 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYAHKYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KvMS+L416Bi0tiYxZgL+8yWJwUbuHOKjs2AZDU58OOomQR6duJvrgbMCsfkcRf/eAnkoPS+mbf2u/uPM0xBj8ZTu83Qgap+j58dPDCPry4tHx/TZ0tQWWr/LwHSVoEJrtQZWs7l8T5IFI6kuzktM4il20FRXrWh9I3EqevX10po=
Message-ID: <4d8e3fd30801080224ra6332c6m6b61b0db45dd72ca@mail.gmail.com>
Date: Tue, 8 Jan 2008 11:24:15 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/5] Codying style fixes in ./arch/x86/ia32
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, trivial@kernel.org
In-Reply-To: <20080108102003.GC6906@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4d8e3fd30801070335n79d910dbt48d0ef0f3597c670@mail.gmail.com>
	 <20080108102003.GC6906@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 11:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> >  int ia32_classify_syscall(unsigned syscall)
> >  {
> > -       switch(syscall) {
> > +       switch (syscall) {
> >         case __NR_open:
> >                 return 2;
> >         case __NR_openat:
>
> this patch has whitespace damage. (tabs got converted to spaces)
>
> i fixed this up, but the other patches in your queue are corrupted too,
> they have linewraps and tabs->spaces problems as well.

:-/ Sorry about that, I fwed the patch queue with gmail.

> also, please use unique subjects for your patches. Instead of:
>
>   Subject: Codying style fixes in ./arch/x86/ia32
>
> use:
>
>   Subject: x86: coding style fixes in arch/x86/ia32/audit.c
>
> (also please keep them lower case)

OK, will do that when I'll back home.

And I'll send the patch queue using a proper MUA :-)

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
