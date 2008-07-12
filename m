Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYGLMJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYGLMJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYGLMIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:08:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38962 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYGLMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:08:49 -0400
Message-ID: <48789EC3.2070701@firstfloor.org>
Date: Sat, 12 Jul 2008 14:08:35 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andy Lutomirski <luto@myrealbox.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu> <4869D4A3.3020000@zytor.com> <200807012239.44105.rjw@sisk.pl> <486A96C1.2020106@firstfloor.org> <48784F51.1010407@myrealbox.com>
In-Reply-To: <48784F51.1010407@myrealbox.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski wrote:
> My Lenovo X61s fails to resume if I suspend it from within X, on both
> 2.6.26-rc9 and recent wireless-testing.  2.6.26-rc8 is fine, as is
> wireless-testing with 4b4f7280 reverted.  My in-progress bisect between
> -rc8 and -rc9 is also consistent with this being the problem.

With "this" do you mean the patch being applied or not applied?

As in does it fail with the patch applied?

You can confirm that by only applying the patch and testing.

-Andi

