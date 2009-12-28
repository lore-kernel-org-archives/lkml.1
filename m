Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbZL1WlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbZL1WlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZL1WlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:41:06 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:54505 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZL1WlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:41:05 -0500
X-Greylist: delayed 1508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Dec 2009 17:41:04 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19257.11789.248634.904859@stoffel.org>
Date: Mon, 28 Dec 2009 17:15:41 -0500
From: "John Stoffel" <john@stoffel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Alain Knaff <alain@knaff.lu>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.33-rc1: LZMA kernel fails to decompress
In-Reply-To: <4B390836.70100@zytor.com>
References: <200912211643.18173.tvrtko.ursulin@sophos.com>
	<4B2FEC10.6050900@msgid.tls.msk.ru>
	<4B37AC87.1070607@knaff.lu>
	<4B37C159.5080202@msgid.tls.msk.ru>
	<4B390836.70100@zytor.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "H" == H Peter Anvin <hpa@zytor.com> writes:

H> On 12/27/2009 12:19 PM, Michael Tokarev wrote:
>> 
>> What I think should be done here is to revert my patch (that replaces
>> /bin/echo with printf, so that /bin/echo will be used) and test the
>> real solution, which is to stop doing all this hackery altogether,
>> and calculate the size the right way instead.  Sam already posted a
>> possible solution, and it seems to be correct.
>> 

H> Yes, but it moves the calculation from generic to x86-specific code,
H> which makes it problematic.

H> I never figured out how to make a generic rule in Kbuild (unlike in
H> standard GNU make) depend on a helper application, but doing a
H> helper application for this is probably the sane thing.

H> Either this, or use Perl, which handles this kind of crap sanely.
H> I'm really less than half joking.

Yeah, I've never understood this mania to purge the build process of
any and all use of perl.  If anything, it should *all* be perl so as
to simplify the maint since it's all the same, no matter where you run
perl.

And for those who say "but I need to compile the kernel in my
miniscule, locked down environment" my reply is "cross-compile".

Heck, even pure C code would do the trick here.

John
