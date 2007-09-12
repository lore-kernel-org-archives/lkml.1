Return-Path: <linux-kernel-owner+w=401wt.eu-S1765913AbXILVHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765913AbXILVHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933123AbXILVG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:06:26 -0400
Received: from spirit.analogic.com ([204.178.40.4]:3873 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbXILVGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:06:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 12 Sep 2007 21:05:22.0017 (UTC) FILETIME=[A1A8ED10:01C7F580]
Content-class: urn:content-classes:message
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
Date: Wed, 12 Sep 2007 17:05:58 -0400
Message-ID: <Pine.LNX.4.61.0709121659410.8879@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0709122222010.32380@fbirervta.pbzchgretzou.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Building a kernel-source RPM (not a kernel RPM)?
Thread-Index: Acf1gKGyL7QX++57RRyEssrSQQgAOQ==
References: <pan.2007.09.12.16.13.41.195991@gmail.com>  <20070912170529.GA18311@uranus.ravnborg.org>  <1189617081.31502.78.camel@tara.firmix.at>  <20070912175116.GB18311@uranus.ravnborg.org>  <1189620642.31502.104.camel@tara.firmix.at>  <20070912181621.GA18688@uranus.ravnborg.org> <1189621385.31502.111.camel@tara.firmix.at> <Pine.LNX.4.64.0709122222010.32380@fbirervta.pbzchgretzou.qr>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "Bernd Petrovitsch" <bernd@firmix.at>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Dan Stromberg" <dstromberglists@gmail.com>,
       <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Sep 2007, Jan Engelhardt wrote:

>
> On Sep 12 2007 20:23, Bernd Petrovitsch wrote:
>> On Wed, 2007-09-12 at 20:16 +0200, Sam Ravnborg wrote:
>>>>
>>>> But we are talking[0] about a kernel-source-$VERSION.$ARCH.rpm's
>>>> which contain the kernel sources (read: lots of .c and .h files,
>>>> etc.) - including a matching .config and after `make oldconfig` - so
>>>> that one can build out-of-tree modules after installing it with
>>>> "KSRC=" (or whatever the Makefile parameter is usually called).
>>>
>>> You need certain things of the kernel built before you can build
>>> external modules (if they use a sane build approach). Just including
>>> the .config with the kernel source is far from enough.
>>
>> ACK. That all must be done/prepared correctly for the
>> kernel-source-*.rpm. And nobody said it is trivial or easy.
>
> Trivial as far as SUSE goes. Install the binary package and you get all
> the symvers, modvers, and everything of the O= part that is needed. That
> is because symvers are per-binary image and not per-source.
>
> Remain the Makefiles, which are in (the big) kernel-source rpm :-/
>
>
>
> 	Jan

If his base package was RedHat, he can just download the sources
he wants, from ftp.kernel.org, un-tar the *.gz file into /usr/src,
then copy the .config used to build the existing kernel from /boot.
It is called /boot/config-`uname -r`. Copy that to the new
kernel tree as ".config" then chdir to that tree and execute
`make oldconfig`. Some questions will have to be answered because
the newer kernel will have additional drivers.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
