Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbXHOKUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbXHOKUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXHOKUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:20:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49962 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXHOKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:20:29 -0400
Date: Wed, 15 Aug 2007 12:20:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <46C2CE42.4010303@gmail.com>
Message-ID: <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <20070814232107.GA4265@aurum.uhlenkott.net>
 <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
 <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr>
 <46C2CE42.4010303@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 15 2007 11:58, Rene Herman wrote:
>> > > > > NULL is not 0 though.
>> > > > It is.  Its representation isn't guaranteed to be all-bits-zero,
>> > > 
>
> He said the null _pointer_ isn't guaranteed to be all-bits zero. And it
> isn't. Read the standard or the faq.

0 is all-bits-zero.
NULL is 0. ("It is.", above)

Transitively, this would make NULL all-bits-zero.
I might have missed something, though, perhaps that the cast to void* makes it
intransitive.
But leave it at whatever the standard says.

>> > > > but the constant value 0 when used in pointer context is always a
>> > > > null pointer (and in fact the standard requires that NULL be
>> > > > #defined as 0 or a cast thereof).

	Jan
-- 
