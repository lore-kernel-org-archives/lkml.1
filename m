Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbYBVJmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbYBVJmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYBVJl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:41:57 -0500
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19]:31451 "HELO
	web52909.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752554AbYBVJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:41:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fDTFM/QvrLMLZTiMOuZoc2d5Rymt5x9UxjN6AGgAOuLF5GNBfPL/Rm8pguIwSuIgolL9+A3U21SzSecdNCzAJi94/BmVn2Ql1MXC637DjNhoX9nKDgW28c7Q/EcMaiunmSV7I2v5Hx4YaOZhlGDGKPwze+pnvb0YfmH60MHoEzo=;
X-YMail-OSG: fHaL1qIVM1mx5eGUlIAjU8BdEg2J8Hi.Y0pPJAtg9O.ucyMvAar__1s0BQlYZGp5EUc.9NqbfJB6GDiT6OO7ABvcYuurfVV6dH2g2GcY1BwulKduacFz0lL6X8fR9Q--
Date: Fri, 22 Feb 2008 09:41:54 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1 - kernel does not boot; IRQ trouble?
To: Kay Sievers <kay.sievers@vrfy.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <3ae72650802220111s11e68f1ft149d7832e9bebbd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <769836.91421.qm@web52909.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Kay Sievers <kay.sievers@vrfy.org> wrote:
> Greg,
> it seems that:
>   arch/x86/pci/legacy.c :: pci_legacy_init()
> 
> tries to create already created "bridge" symlinks in 2.6.24. So we
> discover the same devices twice? Can this be a reason for the hang?

No, it can't be because it's *not* hanging in this configuration :-). It hangs when I *don't* add
the acpi=noirq option, whereas here it's just adding noise to the dmesg log. (I'm guessing Linux
doesn't call pci_legacy_init() when ACPI takes charge of the IRQs.)

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Inbox. http://uk.docs.yahoo.com/nowyoucan.html
