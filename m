Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbZH3G7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbZH3G7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 02:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZH3G7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 02:59:20 -0400
Received: from smtp1m5.poczta.onet.pl ([213.180.138.32]:52578 "EHLO
	smtp1m5.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZH3G7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 02:59:20 -0400
From: Mario <rety@poczta.onet.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Is acpi_ec_ecdt_probe() broken? (was: Re: ACPI locks hardware devices when it doesn't detect vista)
Date: Sun, 30 Aug 2009 08:59:29 +0200
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <1250945310.14167.150.camel@maxim-laptop> <200908300037.45412.rjw@sisk.pl> <1251588634.15582.0.camel@maxim-laptop>
In-Reply-To: <1251588634.15582.0.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908300859.29494.rety@poczta.onet.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim, 

I did the test regarding last coment from Alexey Starikovskiy on the bugzilla.

>What happens if acpi_ec_ecdt_probe() is not called at all? Do you have same
>hang as with changed order?

That did it. System starts and MIR works ok without setpci solution.

Regards
Mario

Sunday 30 of August 2009 01:30:34 Maxim Levitsky wrote:
> On Sun, 2009-08-30 at 00:37 +0200, Rafael J. Wysocki wrote:
> > On Saturday 29 August 2009, Mario wrote:
> > > Exact model is Compal JFL92.
> > > I've attached a dmidecode output.
> >
> > OK
> >
> > Maxim, Mario, can you create a bug entry in the kernel Bugzilla for this
> > issue and put my address into the CC list in there?
>
> Done,
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14086
>
>
> Best regards,
> 	Maxim Levitsky


