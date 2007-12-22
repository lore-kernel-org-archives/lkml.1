Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXLVPhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXLVPhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 10:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXLVPg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 10:36:59 -0500
Received: from outbound-mail-08.bluehost.com ([69.89.17.208]:40431 "HELO
	outbound-mail-08.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751302AbXLVPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 10:36:58 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 10:36:58 EST
From: "Richard D" <richard@embunus.com>
To: "'Pavel Machek'" <pavel@ucw.cz>
Cc: "'Matthew Bloch'" <matthew@bytemark.co.uk>, <linux-kernel@vger.kernel.org>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz>
In-Reply-To: <20071222134612.GA4098@ucw.cz>
Subject: RE: Testing RAM from userspace / question about memmap= arguments
Date: Sat, 22 Dec 2007 21:00:11 +0530
Message-ID: <000a01c844af$8e76b910$ab642b30$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AchEoQqzCgXTQ7MPSC69bkKKNa/+wQADiDqw
Content-Language: en-us
X-Identified-User: {2260:host187.hostmonster.com:embunusc:embunus.com} {sentby:bopbeforesmtp 121.247.188.187 authed with embunus.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was thinking that by the time userspace is ready, the memory that can be
tested will be less. 

-----Original Message-----
From: Pavel Machek [mailto:pavel@ucw.cz] 
Sent: Saturday, December 22, 2007 7:16 PM
To: Richard D
Cc: 'Matthew Bloch'; linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments

On Sat 2007-12-22 13:42:47, Richard D wrote:
> Cant you, modify bootmem allocator to test with memtest patterns and then
> use kexec (as Pavel suggested) to test the one where kernel was sitting
> earlier?


I do not think you need to modify anything in kernel. Just use
/dev/mem to test areas that kernel doesn't see, then kexec into place
you already tested, and test the rest.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

