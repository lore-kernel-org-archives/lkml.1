Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYIRO4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYIRO4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYIRO4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:56:00 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:55707 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbYIRO4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:56:00 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: ACPI "Soft-off" power button only rebooting system, not powering    off
To: Simon Farnsworth <simon@farnz.org.uk>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>, Andrew Paprocki <andrew@ishiboo.com>,
       LKML <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 18 Sep 2008 17:04:51 +0200
References: <bcXj3-fH-1@gated-at.bofh.it> <bd3HN-9P-11@gated-at.bofh.it> <bd4ul-1dy-43@gated-at.bofh.it> <bdpS9-3CD-19@gated-at.bofh.it> <bdqEr-4Iy-19@gated-at.bofh.it> <bdrAs-5Xa-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KgL3s-0003oM-2a@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Farnsworth <simon@farnz.org.uk> wrote:
>>>>> On Wed 2008-09-17 00:50:03, Andrew Paprocki wrote:

>>>>>> I have an AMD / Award BIOS based system which does not properly shut
>>>>>> off when I hold down the power button for 4 seconds. The BIOS is
>>>>>> configured to have "Soft-off" set to "Delay for 4 seconds" which is
>>>>>> supposed to power the machine off if the button is held that long.

> If you hold it down for 4 or more seconds, the BIOS is supposed to shut
> the machine down without the OS knowing what's happening (no ACPI
> events, just a loss of power). From your problem description, the BIOS
> is noticing *something* about the way Linux sets things up, and
> *choosing* to reboot instead of cutting the power.

Each MB I know takes about eight seconds of pressing the power button to
switch "off". Besides that, having a four-seconds-delay seems rather useless
if you'd switch from "0s -> shutdown, 4 s -> hard shutdown" to "0 s ->
suspend, 4 s -> hard shutdown". I never tried it myself*, but I'd expect
"0 s-> suspend, 4 s -> shutdown, 8 s -> hard shutdown".

If I happen to be correct here, you'd be looking at the wrong side of the
correct tree.


*)I'd fail, because I put in a relais, which would cut the power anyway.


