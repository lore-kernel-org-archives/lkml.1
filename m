Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYGNBbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYGNBbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 21:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYGNBbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 21:31:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59024 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYGNBbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 21:31:33 -0400
Date: Mon, 14 Jul 2008 02:31:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andy Lutomirski <luto@myrealbox.com>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080714013125.GA3681@srcf.ucam.org>
References: <200807010148.02135.rjw@sisk.pl> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <200807132115.08230.rjw@sisk.pl> <487A617B.80707@firstfloor.org> <487A67C3.50000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487A67C3.50000@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 01:38:27PM -0700, H. Peter Anvin wrote:

> The most likely explanation for this is that the VESA BIOS expects to be 
> entered in Big Real Mode (*.limit = 0xffffffff) instead of ordinary Real 
> Mode.  Here is a completely untested patch which changes the segment 
> descriptors to Big Real Mode instead.  It would be worth testing out.

Recent Lenovo BIOSes will read from somewhere just under the 4GB 
boundary if the video BIOS is called, so this sounds likely. 
Unfortunately my T61 is, uh, unhappy right now, so I can't test this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
