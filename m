Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbXLVNqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbXLVNqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXLVNqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:46:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4776 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbXLVNqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:46:24 -0500
Date: Sat, 22 Dec 2007 13:46:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Richard D <richard@embunus.com>
Cc: "'Matthew Bloch'" <matthew@bytemark.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071222134612.GA4098@ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001c84472$74b245e0$5e16d1a0$@com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-12-22 13:42:47, Richard D wrote:
> Cant you, modify bootmem allocator to test with memtest patterns and then
> use kexec (as Pavel suggested) to test the one where kernel was sitting
> earlier?


I do not think you need to modify anything in kernel. Just use
/dev/mem to test areas that kernel doesn't see, then kexec into place
you already tested, and test the rest.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
