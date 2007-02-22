Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXBVR0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXBVR0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXBVR0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:26:15 -0500
Received: from lmv.inov.pt ([146.193.64.2]:43122 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbXBVR0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:26:14 -0500
Message-ID: <20070222172410.yfd76j1g3k48gc44@webmail.inov.pt>
Date: Thu, 22 Feb 2007 17:24:10 +0000
From: jose.goncalves@inov.pt
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070219150508.GD27370@flint.arm.linux.org.uk>
	<45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk>
	<45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk>
	<45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk>
	<f2b55d220702211634s77d23ddem8ee6523ff6020d98@mail.gmail.com>
	<20070222085413.GB15841@flint.arm.linux.org.uk> <45DDB1A6.8020409@inov.pt>
	<20070222165650.GA633@flint.arm.linux.org.uk>
In-Reply-To: <20070222165650.GA633@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.0.4)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Russell King <rmk+lkml@arm.linux.org.uk>:

> On Thu, Feb 22, 2007 at 03:07:18PM +0000, Jose Goncalves wrote:
>> Russell King wrote:
>> > On Wed, Feb 21, 2007 at 04:34:15PM -0800, Michael K. Edwards wrote:
>> >
>> >> Are you using an unpatched gcc 4.1.1?  Its optimizer did nasty things
>> >> to us, at least on an ARM target ...
>> >>
>> >
>> > That's ruled out.  Please think about it for a moment - serial_in()
>> > managed to work correctly most of the time, and then spontaneously
>> > changes its well-defined ABI behaviour in a way that analysis of the
>> > asm doesn't allow it to.
>> >
>>
>> I'm using gcc 3.4.6.
>> But I agree with Russell, if it was such a problem it would hit on the
>> first iteration of my application and not after 1 day of executing the
>> same piece of code...
>
> One thing you might think about is running memtest86 on the machine
> for the same kind of time interval, just in case it's something trivial
> like bad ram.
>

OK. That's another thing to do.

Meanwhile I've switched to another SBC and I'm now running my 
application on the new unit. Lets wait and see...

José Gonçalves


