Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYGNCnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYGNCnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYGNCnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:43:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbYGNCnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:43:05 -0400
Message-ID: <487ABB81.8020100@zytor.com>
Date: Sun, 13 Jul 2008 19:35:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <200807132115.08230.rjw@sisk.pl> <487A617B.80707@firstfloor.org> <200807132229.43140.rjw@sisk.pl>
In-Reply-To: <200807132229.43140.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> If s3_bios depends on the (invalid) contents of the hidden part of any segment
> register, it's just terminally broken.
> 

Depending on it being in Big Real Mode isn't all that broken, however, 
especially on laptops where the vendor has control over the system 
BIOS/video BIOS.

Enabling BRM by default *shouldn't* break anything, so it might be what 
we want to do anyway.

	-hpa
