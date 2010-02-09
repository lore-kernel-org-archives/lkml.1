Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0BIQio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:38:44 -0500
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:40023 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754927Ab0BIQim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:38:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [Q] i2c-taos-evm bus driver
Date: Tue, 9 Feb 2010 11:38:37 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902152FBE@mi8nycmail19.Mi8.com>
In-Reply-To: <20100209091639.5b6e39a5@hyperion.delvare>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Q] i2c-taos-evm bus driver
Thread-Index: AcqpYDeCppYKt5X6SBGAkJc09mHCxAARO8kg
References: <BD79186B4FD85F4B8E60E381CAEE190902152F0E@mi8nycmail19.Mi8.com> <20100209091639.5b6e39a5@hyperion.delvare>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>, "Linux I2C" <linux-i2c@vger.kernel.org>
X-OriginalArrivalTime: 09 Feb 2010 16:38:40.0036 (UTC) FILETIME=[55AA2640:01CAA9A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 09, 2010 1:17 AM, Jean Delvare wrote:
> Hi Hartley,

Hello

> Please send i2c-specific questions to the linux-i2c list, as specified
> in MAINTAINERS.

Sorry about that.

> On Mon, 8 Feb 2010 18:15:26 -0500, H Hartley Sweeten wrote:
>> Is the i2c-taos-evm bus driver broken?
>
> No, it works reasonably fine. I was using it myself no later than one
> month ago. Out of curiosity, with which exact evaluation module do you
> plan to use it?

I'm not actually...

I am trying to figure out how a serio driver actually gets "hooked" to a
serial port.  The i2c-taos-evm driver looked simple enough to play with
in order to figure it out.  I was trying to follow the Documentation in
order to use it and ran into the issue below.

>> The Documentation says to use the following to tell the kernel that
>> the device is on the first serial port:
>> 
>> # inputattach --taos-evm /dev/ttyS0
>> 
>> When I try that I get:
>> 
>> inputattach: invalid mode
>> 
>> I checked the source for inputattach on my system (Debian 5.0) and
>> --taos-evm is missing.  And I have not been able to locate a newer
>> version of the user-space utility.
>> 
>> Should this driver be marked broken?
>
> No. What is broken is input-utils' upstream. I tried submitting patches
> 2.5 years ago:
>  http://sourceforge.net/tracker/?group_id=3063&atid=303063
>
> As you can see, nobody took care of them. Apparently I then did not
> even bother sending the one adding support for the TAOS EVM.

Yeah.  I did a bit of searching yesterday and it appears the user space
tools development went stale around the end of the 2.4 - start of the 2.6
kernel.

> The patch in question is still applied to the openSUSE version of the
> input-utils package. If you have access to the openSUSE build system,
> you can see it here:
>   https://build.opensuse.org/package/view_file?file=input-utils-add-taos-evm-support.patch&package=input-utils&project=openSUSE%3A11.0

> In case you don't, I'm attaching it too. I might add it to the patch
> tracking system on sourceforge too. Not that I really expect upstream
> to pick it in a timely manner, but at least other distributions would
> see it and may decide to include it.
> 
> Hope that helps,

That helps.  Thanks.

Do you know if there is a way to make the connection in kernel?

Also, do you know if there is any information on the serio stuff
available anywhere?  Other than just reading the kernel source I
have not been able to locate anything.

Thanks for the reply,
Hartley
