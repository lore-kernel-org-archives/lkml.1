Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbXDQO7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbXDQO7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbXDQO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:59:34 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4241 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXDQO7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:59:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 17 Apr 2007 14:59:29.0324 (UTC) FILETIME=[FFB2CEC0:01C78100]
Content-class: urn:content-classes:message
Subject: Re: ZFS with Linux: An Open Plea
Date: Tue, 17 Apr 2007 10:59:27 -0400
Message-ID: <Pine.LNX.4.61.0704171135490.16847@chaos.analogic.com>
In-Reply-To: <20070417131045.GB18373@thunk.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ZFS with Linux: An Open Plea
Thread-Index: AceBAP+8uc8Xea7JSuWs5xqFDPwaXg==
References: <op.tqw1g6n0ftfxs2@localhost.localdomain> <20070417131045.GB18373@thunk.org>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: "David R. Litwin" <presently42@gmail.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Apr 2007, Theodore Tso wrote:

> On Tue, Apr 17, 2007 at 02:54:32AM -0400, David R. Litwin wrote:
>>> The license that protects the code we write is far from nonsense.
>>
>> I know. In the end, this is the reason this topic is being discussed.
>>
>> I suggest the first thing you do is contact the ZFS developers and
>> convince them to release their code under a license that's GPL
>> compatible, then we can start looking at a Linux port.
>>
>> I began by contacting them. One of the devs there told me to contact the
>> Linux devs.
>
> Well, that was totally useless answer from the ZFS developers.  What
> he should have told you is to contact Sun management, since they are
> the only ones who can decide whether or not to release ZFS under a GPL
> license, and more importantly, to give a patent license for any
> patents they may have filed in the course of developing ZFS.  This is
> not anything Linux developers can help you with.
>
> 						- Ted

Copyright law protects an implementation, not a specification. If
there is a specification for a particular file-system, then certainly
one can create a compatible one without violating any copyrights. Patents
protect algorithms and other implementation details. Certainly, there
are at least a hundred ways of performing the same function using
a programming language, and if you never look at somebody else's'
implementation details, you certainly should not be violating a patent.

So, what needs to be done is simply find out the specifications of
the file-system. From the specifications, one writes compatible code.
To protect "IP," you might have to give it a different name than "ZFS,"
but you certain should be able to write code that handles ZFS format
files. The patent (pending) seems to work around the little/big endian
issue. So, there is probably something in a header somewhere that resolves
this --big deal, machines that are incompatible will have to suffer
byte-swapping overhead. There are also 64-bit checksums for some reason.
I guess they have bad hardware and needed a work-around. The 128-bit
file-size follows the, "if a little is good, more must be better..."
logic that became prevalent in industry once sales persons and accountants
took over engineering.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
