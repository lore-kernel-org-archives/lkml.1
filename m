Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbXIIEZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbXIIEZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 00:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXIIEYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 00:24:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:38101 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbXIIEYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 00:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a2YiE2FD9dbpSrcsn2ury3hFCde0eaPvaNdNZ+QsCIFbFXYPGKX49AEd+o2rCLQiXKSgfjGHv3Ok7pzPcHmXNSsj65b1q2WsevDKM7gRUCKc6dh2UeYcH2Fg34W3o044NhraF/Unza5hAYvnvdkK4gxIkYjXwhUD/OTnl3Mq4PI=
Message-ID: <86802c440709082124q518b5873v5f8a4d6416b1186a@mail.gmail.com>
Date: Sat, 8 Sep 2007 21:24:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "James C. Georgas" <jgeorgas@georgas.ca>, "Andi Kleen" <ak@suse.de>
Subject: Re: broken ACPI NUMA config option
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1189309736.13467.77.camel@Tachyon.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1189291899.13467.20.camel@Tachyon.home>
	 <20070908180904.656f3d03.randy.dunlap@oracle.com>
	 <20070908181607.4f36479c.randy.dunlap@oracle.com>
	 <1189309736.13467.77.camel@Tachyon.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/07, James C. Georgas <jgeorgas@georgas.ca> wrote:
> On Sat, 2007-08-09 at 18:16 -0700, Randy Dunlap wrote:
>
> > 2.6.23-rc5-git1 builds for me when I follow those steps...
> > except for some Section mismatch warnings.
> >
>
> OK, it worked for me also, using torvalds/linux-2.6.git. The behaviour
> of the "select" directive in Kconfig appears to have changed since
> 2.6.22.6. It now turns on ACPI, even when PM is not selected.
>
> This still looks broken to me, because ACPI gets selected by ACPI_NUMA,
> and ACPI depends on PM, but PM is not selected. It works out in the end,
> as far as the build is concerned, but it still bugs me.
>
> Does anyone object to the idea of a selected item automatically
> selecting its own dependencies?
>
> For example, you would only need to specify one "select" directive in
> X86_64_ACPI_NUMA, (i.e. to turn on ACPI_NUMA). The configuration system
> would then recursively walk up ACPI_NUMA's dependency hierarchy, turning
> on what it needed.

dont know my old patch still can be applied or not..
http://lkml.org/lkml/2007/4/4/17

Andi was talking about to use ACPI numa aka SRAT table, but not use dsdt ....

YH
