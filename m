Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZF1E0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZF1E0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 00:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbZF1E0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 00:26:40 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:54963 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZF1E0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 00:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LomOUYD12saRi3db5I5ettd/MCXEZ984jvVoP6OysloazdrbIUNfQkYgynT5QSGAcy
         VfPpWt3IWaR9jQmnn9e7p+vf76ptEvD6yZun5HvieqwEpD7hEluedhttfaIdQdpS55tl
         q5BwJePfeULAJYsXnfwVZbsus4DwrTuDCCsXc=
MIME-Version: 1.0
In-Reply-To: <20090628034038.GK20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net>
Date: Sat, 27 Jun 2009 21:26:42 -0700
Message-ID: <86802c440906272126s7d3b97afh16069280bd297827@mail.gmail.com>
Subject: Re: ACPI issues on HP DL585 G2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Stephen Frost <sfrost@snowman.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 8:40 PM, Stephen Frost<sfrost@snowman.net> wrote:
> Greetings,
>
>  When running pretty much anything newer than 2.6.22, both the cciss
>  module and the bnx2 module get stuck in a "Loading" state in
>  /proc/modules.  As cciss contains my root partition, I get dropped
>  into an initrd after a while because root can't be found.  After some
>  googleing, etc, I saw a bunch of recommendations to add
>  "pci=noapic noapic" to the command-line.  After I did that, the box
>  booted fine under 2.6.29.  I figured people might like to hear about
>  this issue though.  Attached are a dmesg from 2.6.22 and a dmesg from
>  2.6.29 (w/ the noapic options).  I've also included the output of
>  hpasmcli -s "show server".  If there's anything else that would be
>  useful to help figure this out, please let me know.

[    0.000000] nr_irqs_gsi: 38


in madt
ACPI: IOAPIC (id[0x08] address[0xf7cf0000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xf7cf0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xf7fd0000] gsi_base[24])
IOAPIC[1]: apic_id 9, address 0xf7fd0000, GSI 24-30
ACPI: IOAPIC (id[0x0a] address[0xf7fe0000] gsi_base[31])
IOAPIC[2]: apic_id 10, address 0xf7fe0000, GSI 31-37
ACPI: IOAPIC (id[0x0b] address[0xf7ff0000] gsi_base[38])
IOAPIC[3]: apic_id 11, address 0xf7ff0000, GSI 38-61


please try to 2.6.29.x stable

or

try 2.6.30

YH
