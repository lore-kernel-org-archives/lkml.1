Return-Path: <linux-kernel-owner+w=401wt.eu-S1750944AbXAXPVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbXAXPVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbXAXPVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:21:08 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:20941 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXAXPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l7D3Klqt1CktkYluDG01Y039sAvVbCM+QlaLKTSSHcFf8ET22dBJXdmppBIxT8T3rpb9hUOeBX2EKsZw6YRl4gNKpzbq/taAatZJ3K6K3ylhMkHeSaNTije1G/VmOvt/AsbyYFQ1K4oPBOYRoNdqVTdHGs/BUqgSROB25kGjoOA=
Message-ID: <3877989d0701240721lcba4833p76aa14802e3620f7@mail.gmail.com>
Date: Wed, 24 Jan 2007 23:21:04 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Eamonn Hamilton" <EAMONN.HAMILTON@saic.com>
Subject: Re: IO-APIC + timer doesn't work - 2.6.20-rc5 on abit KN9-Ultra bios 1.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1169630914.22508.151.camel@ukabzc383.uk.saic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1169630914.22508.151.camel@ukabzc383.uk.saic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

what about acpi=off?

On 1/24/07, Eamonn Hamilton <EAMONN.HAMILTON@saic.com> wrote:
> Hi,
>
> I can't get any kernel up to 2.6.20-rc5 to boot without using noapic on
> an ABIT KN9-Ultra with a dual-core Athlon.
>
> I booted with apic=debug as suggested and got the following :
>
> ENABLING IO-APIC IRQs
> .. TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
> .. MP-BIOS bug: 8254 timer not connected to IO-APIC
> ... trying to set up timer (IRQ0) through the 8252A ... failed
> ... trying to set up timer as Virtual Wire IRQ ... failed
> ... trying to set up timer as ExtINT IRQ ... failed :(
>
> The bios is the latest, although in various posts on the web it would
> appear this occurs in older versions also.
>
> What can I do to help resolve this?
>
> Cheers,
> Eamonn
> --
> Eamonn Hamilton <eamonn.hamilton@saic.com>
>
>
> --
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
