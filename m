Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbYB2S1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbYB2S1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYB2S1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:27:30 -0500
Received: from spirit.analogic.com ([204.178.40.4]:4812 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYB2S13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:27:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 29 Feb 2008 18:24:14.0644 (UTC) FILETIME=[49AE5F40:01C87B00]
Content-class: urn:content-classes:message
Subject: Re: 64-bit sources
Date: Fri, 29 Feb 2008 13:24:09 -0500
Message-ID: <Pine.LNX.4.61.0802291323190.23352@chaos.analogic.com>
In-Reply-To: <28962.1204303003@turing-police.cc.vt.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 64-bit sources
Thread-Index: Ach7AEm4o5FSGBI0TcSoo3wq9v4klw==
References: <Pine.LNX.4.61.0802290954390.22942@chaos.analogic.com> <Pine.LNX.4.64.0802291631020.24056@fbirervta.pbzchgretzou.qr>            <Pine.LNX.4.61.0802291123280.23162@chaos.analogic.com> <28962.1204303003@turing-police.cc.vt.edu>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay, Thanks. I "think" I am compiling it now!
There are lots of warnings, but it didn't blow up (yet)!


On Fri, 29 Feb 2008 Valdis.Kletnieks@vt.edu wrote:

> On Fri, 29 Feb 2008 11:25:58 EST, "linux-os (Dick Johnson)" said:
>>
>> Yes. The RPM contains only patches and the patches won't
>> patch a 2.6.11 kernel either! Perhaps they need to be
>> in some undefined order.
>
> Umm... I just checked that specific RPM, and that RPM *does* contain all that
> you need. In particular, the following *are* in there:
>
> kernel-2.6.spec
> linux-2.6.11.tar.bz2
> patch-2.6.12-rc5-neutered.bz2  <- probably why they won't patch a 2.6.11
>
> The spec file lists all the *.patch files and the order to apply them in.  It
> even has a whole bunch of *.config files.
>
> Your best best is to 'rpm -ivh' that RPM - that will put the pieces in
> /usr/src/redhat/SOURCES and /usr/src/redhat/SPECS.  'rpmbuild kernel.spec'
> (with appropriate flags, you probably want '--target x86_64' if you want
> a  64-bit build only).  Adding patches is a matter of dropping the patch in
> /usr/src/redhat/SOURCES and adding a few lines to the kernel-2.6.spec file.
>
>
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
