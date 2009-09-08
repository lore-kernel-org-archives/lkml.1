Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZIHUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZIHUrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZIHUrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:47:32 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:37324 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZIHUrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tGBOMgTzdruxOjnF9tUCkloRJTKFFPm1VYpy0mzhLQrzOsHkqiFkq+KBKPuNXYWvdi
         v29rUaQun/h4h7RpTQIx2I5hv2G7wZym9pvYCArojqsnARuibq4e4uuo+/7ZTxc0Llvk
         iyqwv37+iwv41UtS3P3++bMw42n9y8EymXoIY=
Subject: Re: Machine resumes straight after suspend to RAM (or disk)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <b2cdc9f30909081157r3087f707ve3a0cff77f46941a@mail.gmail.com>
References: <b2cdc9f30909081157r3087f707ve3a0cff77f46941a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Sep 2009 23:47:27 +0300
Message-Id: <1252442847.16422.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 19:57 +0100, Alex Bennee wrote: 
> Hi,
> 
> I thought I'd enable suspend and resume on my desktop machine so I
> could save myself some time in the morning when I restart the machine.
> The machine is fairly standard Intel Core Duo based system (lspci
> attached). However when I execute pm-suspend (or Gentoo's own
> hibernate-script) the system does suspend but resumes immediately. To
> add insult to injury the ethernet doesn't come back properly and needs
> a reboot to reset it.
> 
> I've played about a little with the ACPI debug stuff but it's easy to
> overflow the dmesg buffer. The relevant section around the
> suspend/resume looks like:

Try to unload ehci_hcd before suspend.

Best regards,
Maxim Levitsky

