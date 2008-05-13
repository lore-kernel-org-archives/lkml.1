Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYEMH4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYEMH4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYEMH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:56:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:52799 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbYEMH4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:56:22 -0400
X-IronPort-AV: E=Sophos;i="4.27,478,1204520400"; 
   d="scan'208";a="53446909"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Date: Tue, 13 May 2008 08:53:42 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D015A1702@limkexm3.ad.analog.com>
In-Reply-To: <8bd0f97a0805120959gee0f56bv746545c9b86ef7bd@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Thread-Index: Aci0UZZNCn5E7FXDRx2oQF6C8ymF1AAfDVMQ
References: <1210587437-9751-1-git-send-email-cooloney@kernel.org> <8bd0f97a0805120547g5c46973fl538ad18d81a4aebc@mail.gmail.com> <386072610805120742k47e2433cxf7a1f8605fca47fb@mail.gmail.com> <200805120954.06986.david-b@pacbell.net> <8bd0f97a0805120959gee0f56bv746545c9b86ef7bd@mail.gmail.com>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>,
       "David Brownell" <david-b@pacbell.net>
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       <dbrownell@users.sourceforge.net>, <dmitry.torokhov@gmail.com>,
       <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 13 May 2008 07:56:20.0861 (UTC) FILETIME=[D4ECCAD0:01C8B4CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Mike Frysinger [mailto:vapier.adi@gmail.com]
>Sent: Montag, 12. Mai 2008 19:00
>To: David Brownell
>Cc: Bryan Wu; pHilipp Zabel; dbrownell@users.sourceforge.net;
>dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org; Michael
Hennerich
>Subject: Re: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current
>blackfin specific pfbutton driver with kernel generic gpio key driver
>
>On Mon, May 12, 2008 at 12:54 PM, David Brownell wrote:
>> On Monday 12 May 2008, Bryan Wu wrote:
>>  > Right. I mean the generic GPIO layer in Blackfin port, not the
common
>code.
>>  >
>>  > And on the other hand, maybe there are also other hardware which
has
>similar
>>  > issue as Blackfin. So the common GPIO layer can take care of this,
how
>>  > do you think, David?
>>
>>  No; it's a Blackfin-specific design flaw, one that I've not seen
>>  in any other chip's GPIO support.  So it should stay in the Blackfin
>>  support code.  (Possibly even specialized for the specific chips
>>  which have that flaw/erratum.)
>
>afaik, it was a design flaw, not an erratum ... newer parts have the
>situation rectified.  but Michael would be able to comment more
>authoritatively on the topic.  we already have the logic to only make
>the swap for parts that need it.
>-mike

I agree with all. This hack patch shouldn't be discussed here. I must
have overseen this while we discussed what to send upstream.

Please disregard.

-Michael

