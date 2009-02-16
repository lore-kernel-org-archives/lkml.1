Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZBPAWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZBPAWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZBPAWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:22:07 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:60950 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZBPAWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:22:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18840.45474.829954.528820@stoffel.org>
Date: Sun, 15 Feb 2009 19:21:54 -0500
From: "John Stoffel" <john@stoffel.org>
To: Philippe Grenard <philippe.grenard@laposte.net>
Cc: linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       John Stoffel <john@stoffel.org>, Len Brown <lenb@kernel.org>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
In-Reply-To: <200902151317.11690.philippe.grenard@laposte.net>
References: <200902131944.56634.philippe.grenard@laposte.net>
	<200902140917.38313.philippe.grenard@laposte.net>
	<3f9a31f40902140124j4bb07aeej8af3dff89e347318@mail.gmail.com>
	<200902151317.11690.philippe.grenard@laposte.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philippe" == Philippe Grenard <philippe.grenard@laposte.net> writes:

Philippe> On Saturday 14 February 2009 10:24:51 Jaswinder Singh Rajput wrote:
>> On Sat, Feb 14, 2009 at 1:47 PM, Philippe Grenard
>> 
>> <philippe.grenard@laposte.net> wrote:
>> > On Friday 13 February 2009 21:48:30 John Stoffel wrote:
>> >> Here's your problem most probably.  The nVidia graphics module.
>> >> Remove that and re-try your system.  Basically, we can't help you when
>> >> you use a vendor's binary module.
>> >>
>> >> John
>> >
>> > Well, it does not change anything to my problem...
>> > Moreover, I don't understand why this would work with 2.6.27.10 but not
>> > with 2.6.29-rc4 ....
>> 
>> May be nvidia graphics module was written based on some kernel which
>> is more closer to 2.6.27.10 as compare to 2.6.29-rc4.
>> 
>> Another thing which John is pointing configure your bios to use
>> standard inbuild garphics card OR remove nvidia module and check
>> whether it solves your problem or not.
>> 
>> --
>> JSR

Philippe> As I said just before, I tried it but it does not change my
Philippe> problem : the system still stalls randomly, sometimes during
Philippe> boot, sometimes after...

This smells even more of hardware problems then.  Did you change
anything recently besides your kernel?  And does the system still
reliably run with the older kernel?  

If you have a second Linux computer, you can setup a newconsole to
hopefully capture and then post more details about your system when it
boots and crashes.

I'd personally pull any extra disks, re-seat memory, turn down the
systems settings in the BIOS to very conservative numbers, etc.  No
overclocking at all.  

Also, try removing all but one memory module and seeing if that helps.

John

