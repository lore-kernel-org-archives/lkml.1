Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYLZXKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYLZXKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 18:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYLZXKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 18:10:36 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:53851 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYLZXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 18:10:36 -0500
Message-ID: <006201c967af$24c29740$6602a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: "Jan Engelhardt" <jengelh@medozas.de>
Cc: <linux-kernel@vger.kernel.org>, "Sam Ravnborg" <sam@ravnborg.org>
References: <005401c96797$df055100$6602a8c0@bui.materna.com> <alpine.LSU.2.00.0812262134270.12031@fbirervta.pbzchgretzou.qr>
Subject: Re: [PATCH] Compress kernel modules on installation
Date: Sat, 27 Dec 2008 00:10:28 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Provags-ID: V01U2FsdGVkX18DLPaUqF8r6Gpsn5VNadX+f+ucIPDbtEMF6U77
	uIlQNIHHRk2bEu1xNUeroVLBv709ycy9sNNHyWYgtXMS/EFKQr
	Hz40z/6Sg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Friday 2008-12-26 21:23, Roland wrote:
>
>> what about some "make modules_install_compressed" instead ?
>>
>> as i have run out of diskspace quite often when installing test kernels, 
>> i
>> think we really need a feature like this.
>>
>> i`d also favour the makefile approach.
>> why another kconfig option?
>>
>> jan`s patch looks clean and simple, but i think it`s a little bit 
>> intrusive...
>
> Why so? module-ini

with "intrusive" i meant, that all modules are now compressed by default and 
there is no switch to build them uncompressed.
so you change a long established default which may not be welcomed by 
everyone and give no option for conservative people.

we should take care and not break things.
default uncompressed, compressed implented as an option is a better 
strategy, imho.
discuss changing the default at a later time then.

roland

>>
>> regards
>> roland
>>
>> ps:
>> i`d use gzip without "-9" as this gives very little space savings. it 
>> mostly
>> burns cpu and slows things down too much.
>> ( see
>> http://www.linuxjournal.com/files/linuxjournal.com/linuxjournal/articles/080/8051/8051f1.png
>
> Here is one that is tailored for kernel modules:
> http://tinyurl.com/8f2xta
> Looks pretty much like the one from LJ but of course, .ko files
> compress better than LJ :)
> Oh well. 

