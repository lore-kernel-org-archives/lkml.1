Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYBERpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYBERpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYBERpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:45:40 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:57499 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYBERpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:45:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18344.41128.159384.144803@stoffel.org>
Date: Tue, 5 Feb 2008 12:45:12 -0500
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
In-Reply-To: <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
References: <20080130011550.GA31853@elte.hu>
	<200802050436.31070.maximlevitsky@gmail.com>
	<alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> On Tue, 5 Feb 2008, Maxim Levitsky wrote:
>> 
>> The x86 tree was merged several times, but I don't see kgdb included in 
>> latest mainline -git.
>> 
>> So just one question, will it be included or no?

Linus> I won't even consider pulling it unless it's offered as a
Linus> separate tree, not mixed up with other things. At that point I
Linus> can give a look.

Linus> That said, I explained to Ingo why I'm not particularly
Linus> interested in it.  I don't think that "developer-centric"
Linus> debugging is really even remotely our problem, and that I'm
Linus> personally a lot more interested in infrastructure that helps
Linus> normal users give better bug-reports. And kgdb isn't even
Linus> _remotely_ it.

Linus> So I'd merge a patch that puts oops information (or the whole
Linus> console printout) in the Intel management stuff in a
Linus> heartbeat. 

How about we put in some sort of console logging tool so we can buffer
and log the console output better?  Currently if I have both a serial
and tty console defined, my GDM prompter looses the mouse until I goto
the XDMCP chooser and back again.  

I'm pretty sure it's a GDM problem, since Xdm doesn't have this issue
at all.  Haven't had time to chase it though.

In any case, having some way to log oopses better would be really
nice.  Not sure how we could do it reliably for suspend/resume needs
on laptops without dedicated management hardware like the ILOM stuff
on Intel/Sun boxes.  

Dunno... just viocing my desires...
John
