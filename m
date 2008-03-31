Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbYCaVES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbYCaVES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYCaVEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:04:05 -0400
Received: from eazy.amigager.de ([213.239.192.238]:50115 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbYCaVED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:04:03 -0400
Date: Mon, 31 Mar 2008 23:04:44 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Mark Lord <lkml@rtr.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Message-ID: <20080331210444.GA29284@dose.home.local>
Mail-Followup-To: Mark Lord <lkml@rtr.ca>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>
References: <200803220259.48534.rjw@sisk.pl> <alpine.LFD.1.00.0803311118120.14670@woody.linux-foundation.org> <47F13B8F.1000003@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F13B8F.1000003@rtr.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 15:29:19 -0400, Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:
>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10291
>>> Subject		: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core Duo
>>> Submitter	: Tino Keitel <tino.keitel@gmx.de>
>>> Date		: 2008-03-20 07:05 (2 days old)
>>> References	: http://lkml.org/lkml/2008/3/20/23
>>
>> Hmm. I just tested mine, and it still works fine (current -git,  
>> obviously). But as usual, I tend to run different kernel configs than 
>> most people (no modules, only drivers that are actually useful). So I 
>> think this needs bisecting or something.
> ..
>
> I wonder if this is related to the USB suspend/resume bug I see here?
>
> One way to tell, is to rebuild the kernel with CONFIG_USB_SUSPEND=n.
> If suspend/resume then works, we might well be looking at the same bug.

I already tried this, without success:

$ grep CONFIG_USB_SUSPEND /boot/config-2.6.25-rc7 
# CONFIG_USB_SUSPEND is not set

Regards,
Tino
