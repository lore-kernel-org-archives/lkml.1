Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYGANDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYGANDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYGANCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:02:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34659 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYGANCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:02:02 -0400
Message-ID: <486A2AC3.2060107@firstfloor.org>
Date: Tue, 01 Jul 2008 15:01:55 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu> <4869D67B.4060902@zytor.com>
In-Reply-To: <4869D67B.4060902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It still seems incredibly risky to push this for 2.6.26, especially
> given the Elan revelation.

Do Elans even support S3?

>  I think it needs to be tested on the 2.6.27
> track, and then possibly be pushed back via the 2.6.26-stable route.

I'm just not sure how many suspend/resume cycles people really do
on a early (pre -rc) mainline kernel (or in linux-next for that
matter). You usually have to install on a laptop and actually
use it.

Since this code is only executed on resume some directed testing
would be better. That is what Rafael asked for in this mail.

I think it would be ok for .26 if we can get confirmation it works
on a few systems with S3 suspend/resume.

-Andi

