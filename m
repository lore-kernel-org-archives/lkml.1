Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZJDUpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZJDUpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbZJDUps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:45:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZJDUpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:45:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
Date: Sun, 4 Oct 2009 22:46:23 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1254669853.26496.0.camel@carter> <ca2dc2820910041046i47a1c3dhba82266bb14a440c@mail.gmail.com> <4AC8F02B.6080209@suse.de>
In-Reply-To: <4AC8F02B.6080209@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910042246.23712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 October 2009, Alexey Starikovskiy wrote:
> Hi Miguel,

Hi Alex,

> I am going to reject your patch on the basis, that the battery driver should report only
> information it gained from battery hardware, not interpret it in any way.
> As your patch fall into "interpret" category, it does not belong in the kernel and battery
> driver in particular. You may suggest it to any/all user space battery monitoring applications,
> this is the place for "interpretations".

Well, we do quirks for PCI devices, suspend quirks etc. in the kernel, so I'm
not really sure we should use the "no interpretation" as a general rule.  IMO,
if there's a known broken system needing a quirk, it may just be more
reasonable to put the quirk into the kernel than to put it into every single
user application out there.

In this particular case we have an evidently quirky hardware (or BIOS) and it's
not a fundamentally wrong idea to try to address that problem in the kernel.

Thanks,
Rafael
