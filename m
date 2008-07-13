Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYGMSX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYGMSX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYGMSXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:23:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59769 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYGMSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:23:46 -0400
Message-ID: <487A4686.209@zytor.com>
Date: Sun, 13 Jul 2008 11:16:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Lutomirski <luto@myrealbox.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl> <20080713085603.GB6890@elf.ucw.cz>
In-Reply-To: <20080713085603.GB6890@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> In such case, you could verify by disabling intel framebuffer and just
> using plain VGA driver (or vesafb).
> 
> Breaking video bios calls would be bad.
> 									Pavel

It would... but it doesn't seem to make much sense.  What, in detail, 
does this particular quirk do?

	-hpa
