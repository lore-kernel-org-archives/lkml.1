Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYA2IUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYA2IUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 03:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYA2IUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 03:20:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:54540 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYA2IUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 03:20:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=atlTfp1dDCvOckDFERCu3AS4i7AB6xbdQToZHeItQyDEl79lu1fI3jEDEUehDRST7jKy69Kmsl4wkoRiP9vYDnrB5j6TKio9fBWTnJm4jKS1zs1vNPYuK39gQyC/XxMHmGReH66M+cSW1BOyNkvkTIeKXfxT2qN8feXUZ7bi+Js=
Message-ID: <86802c440801290020v72238b5fi87a6b7cf739a7e6@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:20:29 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c II
Cc: "Joachim Deguara" <joachim.deguara@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       "Dean Roe" <roe@cray.com>
In-Reply-To: <20080129083112.GA1466@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801281211.28214.joachim.deguara@amd.com>
	 <p73y7a970nd.fsf@bingen.suse.de>
	 <200801282012.47190.yinghai.lu@sun.com>
	 <20080129045659.GA31847@one.firstfloor.org>
	 <20080129080927.GA1414@one.firstfloor.org>
	 <86802c440801282339q77a585f5h82df44295ddfb6fd@mail.gmail.com>
	 <20080129083112.GA1466@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 12:31 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> On Mon, Jan 28, 2008 at 11:39:30PM -0800, Yinghai Lu wrote:
> > On Jan 29, 2008 12:09 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > > > SRAT is essentially just a two dimensional table with node distances.
> > >
> > > Sorry, that was actually SLIT. SRAT is not two dimensional, but also
> > > relatively simple. SLIT you don't really need to implement.
> > >
> >
> > need to add some CONFIG option to parse SRAT, MADT etc only. but don't
> > pull DSDT related...
>
> I don't think it needs a CONFIG. The code should handle this case
> by itself in any case. I'm not entirely sure it does currently, but if it
> doesn't it will likely not be very difficult to fix.
>
> Or are you worried about code size? ACPI is around ~270k on x86-64,
> which while certainly not small should not be a problem on x86 NUMA
> systems.

like acpi=off, acpi=tableonly? so it will load dsdt, and some one
module rely on dsdt could not complain ACPI ERROR..

YH
