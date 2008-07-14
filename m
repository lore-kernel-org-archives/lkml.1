Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYGNHii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYGNHii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYGNHi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:38:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54284 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbYGNHi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:38:29 -0400
Date: Mon, 14 Jul 2008 09:39:16 +0200
From: Pavel Machek <pavel@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080714073916.GC1796@elf.ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <200807132115.08230.rjw@sisk.pl> <487A617B.80707@firstfloor.org> <487A67C3.50000@zytor.com> <487AD37A.2050903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487AD37A.2050903@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-07-13 21:18:02, H. Peter Anvin wrote:
> H. Peter Anvin wrote:
>>
>> The most likely explanation for this is that the VESA BIOS expects to be 
>> entered in Big Real Mode (*.limit = 0xffffffff) instead of ordinary Real 
>> Mode.  Here is a completely untested patch which changes the segment 
>> descriptors to Big Real Mode instead.  It would be worth testing out.
>>
>
> ... and here is one that actually has a prayer of actually working.

I tried 2.6.26, but it does not seem to be broken here :-(. Thinkpad
x60. So it does not seem _all_ thinkpads have this problem... 

									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
