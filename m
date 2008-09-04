Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbYIDUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbYIDUTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYIDUTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:19:03 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:17217 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbYIDUTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:19:01 -0400
From: Frans Pop <elendil@planet.nl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Date: Thu, 4 Sep 2008 22:18:55 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
References: <200808202106.41058.elendil@planet.nl> <200808302116.07421.elendil@planet.nl> <Pine.LNX.4.55.0808302106140.29414@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0808302106140.29414@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809042218.56310.elendil@planet.nl>
X-OriginalArrivalTime: 04 Sep 2008 20:18:58.0691 (UTC) FILETIME=[768D9530:01C90ECB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 August 2008, Maciej W. Rozycki wrote:
> On Sat, 30 Aug 2008, Frans Pop wrote:
> > >  Barring a hardware erratum, this is a bug in the kernel.  It
> > > should be moderately easy to track down with some debugging added
> > > to writes accessing LVT and redirection table entries.
> >
> > Could you please provide some more specific debugging instructions?
> > I'm at a complete loss what I should do here.
>
>  Debugging code can be added to apic_write() and
> io_apic_{write,modify}() so that a warning is output into the kernel
> log whenever a suspicious value is written to one of the vector
> registers.  Similarly for MSI/HT interrupts, although I do not know
> names of the functions involved off the head.  Due to performance
> considerations it is unfortunately infeasible to have such debugging
> enabled in production kernels.

Thanks for the reply Maciej, but that is still way over my head I'm 
afraid. I think I'll need an actual debug patch from someone that I can 
apply and test with to get any further with this.
