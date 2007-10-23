Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbXJWBBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbXJWBBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXJWBBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:01:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:62061 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXJWBBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=IprrF9HbV/Ikrc7zRbFkeMxyUewiEMYkRwDSVZRBSsAqGAqQ3qC0bvg3MUf2TrqS5gaV/2nrXwe9uW2XRElsmCmXkzLWxB2MPPniK+cI3J+Uofn1RpV8S2bfO5RwosaH8bkx9wEJLTo2u3VdY6+Ft5i+Wq/nxDqp3l8TlQTqK1c=
Message-ID: <471D47D2.2070707@googlemail.com>
Date: Tue, 23 Oct 2007 03:01:06 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org
Subject: Re: Resume problems
References: <471CCC98.10101@googlemail.com> <200710230035.32924.rjw@sisk.pl> <471D2B7F.40604@googlemail.com> <200710230131.10917.rjw@sisk.pl> <471D30C0.4050606@googlemail.com> <471D3C26.3090602@googlemail.com>
In-Reply-To: <471D3C26.3090602@googlemail.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Also box just froze on level 3 but I got a ACPI error at least which I didn't got in any other dmesg till now :
> ( also patch was tested with HT disabled and Suspend and Hibernation enabled in kernel and BIOS )
> 
> ...
> 
> Oct 23 01:51:05 lara [  273.512374] PM: Removing info for No Bus:input0
> Oct 23 01:51:05 lara [  274.545158] PM: Removing info for No Bus:mouse0
> Oct 23 01:51:05 lara [  274.551435] PM: Removing info for No Bus:event1
> Oct 23 01:51:05 lara [  274.559493] PM: Removing info for No Bus:input1
> Oct 23 01:53:06 lara [  394.869468] ACPI Error (evevent-0303): No installed handler for fixed event [00000002] [20070126]
> 
> ....
> 
> ( I hard reseted after that ) 
> 
> I try level 2 and 1 now I just wanted to let you know.
> 

Same issues with level 2 and 1.

BTW I found out why my box does not shutdown with acpi=ht. It seems like libata does not like that 
acpi mode =) dropping the '... read http://linux-ata.org/shutdown.html , power down manually' message.

That works perfectly with full acpi here.

After all I think all this problems may be some who ACPI related 
but the question is why they get triggered by Suspend/Hibernation.

If you want me to test something else just let me know.

Gabriel
