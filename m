Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbXG2SSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbXG2SSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762983AbXG2SSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:18:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:53341 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbXG2SSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=UU0iQoliwX73G27qkW84ldLVFYGT8CxVlPCrxgL5rav7PQYTEaq6DXv7RRwfogkIYp52FpTIW+sXyH2fP65HVCP04iIdGSkZgllXJ3hPRotB1QTM61YOpjisJlsUcURTX4S8BwSUYo3J7DHi56tc7n5gmh38MoWdvyL0dUmYhnE=
Message-ID: <46ACD8DB.2020108@googlemail.com>
Date: Sun, 29 Jul 2007 20:13:47 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Frank Hale <frankhale@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com
Subject: Re: ACPI on Averatec 2370
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
In-Reply-To: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Hale wrote:
[ added  linux-acpi to CC ]
> I have an Averatec 2370 laptop with the nVidia MCP51. With kernel
> 2.6.20 I had no issues with ACPI however with 2.6.21 and higher the
> kernel will hang on boot until I press the suspend button or the power
> button in which case the kernel wakes up and finishes the boot
> process. Including the following support only causes the issue:
> 
>  [*] ACPI Support
> 
> What I mean by that is every ACPI option has been deactivated and only
> ACPI support checked. The boot process with 2.6.21 and higher hangs at
> the point where the Scheduler is being registered.
> 
> io scheduler cfq registered (default)
> 
> If I allow it to sit there it never comes back to life and finishes
> booting. If I press the power or suspend button it will finish booting
> as expected.
> 
> I've scoured google for quite a while but cannot find any relevant
> information pertaining to this issue. For now I've disabled ACPI
> altogether.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
