Return-Path: <linux-kernel-owner+w=401wt.eu-S1030420AbXCAWIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030420AbXCAWIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030427AbXCAWIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:08:43 -0500
Received: from sbcsmtp6.sbc.com ([144.160.20.53]:51378 "EHLO
	mlph073.enaf.sfdc.sbc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030420AbXCAWIm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:08:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 3c905B - Transmit error, Tx status register 82
Date: Thu, 1 Mar 2007 16:08:24 -0600
Message-ID: <0D69EE79F863484FB73D20A95656730D02F9CBB3@ILNORT1MSGUSR18.ITServices.sbc.com>
In-Reply-To: <75b66ecd0703011013h704319c4h9f5ad7b572c53b28@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 3c905B - Transmit error, Tx status register 82
Thread-Index: AcdcLVg7Zi9tDzErSu6aTouprfPd9gAIJtEA
From: "WHITE, JOE \(ASI-AIT\)" <jw2365@att.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: <andrewm@uow.edu.au>, <netdev@oss.sgi.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Mar 2007 22:08:25.0224 (UTC) FILETIME=[22134080:01C75C4E]
X-TM-AS-Product-Ver: SMEX-7.0.0.1433-3.6.1039-15028.001
X-TM-AS-Result: No--18.392400-0.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

Thanks for the reply.

We have tried moving my network connection to a new switch, replaced the
cables, but still getting that error.

What do I do with that command options 3c59x full_duplex=1, where do I
put it?  Bare with me as I am a newbie.

Thanks,
Joe

-----Original Message-----
From: rlrevell@gmail.com [mailto:rlrevell@gmail.com] On Behalf Of Lee
Revell
Sent: Thursday, March 01, 2007 12:14 PM
To: WHITE, JOE (ASI-AIT)
Cc: andrewm@uow.edu.au; netdev@oss.sgi.com; linux-kernel@vger.kernel.org
Subject: Re: 3c905B - Transmit error, Tx status register 82


On 3/1/07, WHITE, JOE (ASI-AIT) <jw2365@att.com> wrote:
> Mar  1 09:44:04 thor kernel: Probably a duplex mismatch.  See
> Documentation/networking/vortex.txt

Um... did you check Documentation/networking/vortex.txt?

261	Transmit error, Tx status register 82
262	-------------------------------------
263	
264	This is a common error which is almost always caused by another
host on
265	the same network being in full-duplex mode, while this host is
in
266	half-duplex mode.  You need to find that other host and make it
run in
267	half-duplex mode or fix this host to run in full-duplex mode.
268	
269	As a last resort, you can force the 3c59x driver into
full-duplex mode
270	with
271	
272		options 3c59x full_duplex=1
273	
274	but this has to be viewed as a workaround for broken network
gear and
275	should only really be used for equipment which cannot
autonegotiate.
276	

Lee
