Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYI0Fh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYI0Fh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 01:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYI0FhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 01:37:16 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34470 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbYI0FhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 01:37:15 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>,
       Tim Deegan <Tim.Deegan@citrix.com>
In-Reply-To: <48DDB47E.8050505@zytor.com>
References: <1222472815.29886.43.camel@alok-dev1>  <48DD860C.50809@goop.org>
	 <1222485079.23825.13.camel@alok-dev1>  <48DDB47E.8050505@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 26 Sep 2008 22:37:14 -0700
Message-Id: <1222493834.23825.28.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 21:20 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> >
> > Avoiding existing leaves,
> > Microsoft's Hypervisor  is using levels 0x40000000 - 0x40000005.
> > The first 2 are standard levels and the rest of them are Microsoft
> > hypervisors specific levels. So started with 0x40000010.
> >
> 
> The first two?  And standard according to whom?
I was just quoting Microsoft's documentation that's available on MSDN.
http://msdn.microsoft.com/en-us/library/bb969724.aspx

Maybe by standard they mean standard definitions for them, the meaning
of the rest of the definitions change according to the value returned by
leaf 0x40000001 (Hypervisor vendor-neutral interface id). 

Thanks,
Alok
> 
>         -hpa

