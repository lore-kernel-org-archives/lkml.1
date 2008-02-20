Return-Path: <linux-kernel-owner+w=401wt.eu-S933468AbYBTUOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbYBTUOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbYBTUOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:14:31 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:61857 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYBTUOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:14:30 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 12.53.176.4
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19x5vPDOJR3GkynG84Z+Eln
Message-ID: <47BC89F5.90305@reed.com>
Date: Wed, 20 Feb 2008 15:13:41 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [linux-kernel] Re: [PATCH] x86: use explicit timing delay for
 pit accesses in kernel and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com> <47B9FFD5.6040801@keyaccess.nl> <47BA002B.7070806@zytor.com> <47BA0188.6000808@keyaccess.nl> <47BA077B.50401@keyaccess.nl> <47BA0A3D.1060708@zytor.com> <47BC17BE.9010800@keyaccess.nl> <47BC5DF4.9020300@zytor.com> <47BC5EE3.5090101@keyaccess.nl>
In-Reply-To: <47BC5EE3.5090101@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, disparaging things as "one idiotic system" doesn't seem like a 
long-term thoughtful process - it's not even accurate.  There are more 
such systems that are running code today than the total number of 486 
systems ever manufactured.  The production rate is $1M/month.

a) ENE chips are "documented" to receive port 80, and also it is the 
case that modern chipsets will happily diagnose writes to non-existent 
ports as MCE's.   Using side effects that depend on non-existent ports 
just creates a brittle failure mode down the road.  And it's not just 
post ACPI "initialization".   The pcspkr use of port 80 caused solid 
freezes if you typed "tab" to complete a command line and there were 
more than one choice, leading to beeps.

b) sad to say, Linux is not what hardware vendors use as the system that 
their BIOSes MUST work with.  That's Windows, and Windows, whether we 
like it or not does not require hardware vendors to stay away from port 80.

IMHO, calling something "idiotic" is hardly evidence-based decision 
making.   Maybe you love to hate Microsoft, but until Intel writes an 
architecture standard that says explicitly that a "standard PC" must not 
use port 80 for any peripheral, the port 80 thing is folklore, and one 
that is solely Linux-defined.

Rene Herman wrote:
> On 20-02-08 18:05, H. Peter Anvin wrote:
>  
>> Rene Herman wrote:
>>>
>>> _Something_ like this would seem to be the only remaining option. It 
>>> seems fairly unuseful to #ifdef around that switch statement for 
>>> kernels without support for the earlier families, but if you insist...
>>>
>>
>> "Only remaining option" other than the one we've had all along.  Even 
>> on the one idiotic set of systems which break, it only breaks 
>> post-ACPI intialization, IIRC.
>
> Linus vetoed the DMI switch.
>
> Rene.
>
