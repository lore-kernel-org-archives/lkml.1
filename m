Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbXHOJUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbXHOJUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbXHOJUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:20:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33466 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760893AbXHOJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:20:35 -0400
Date: Wed, 15 Aug 2007 11:20:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <46C2BB60.6010909@gmail.com>
Message-ID: <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <20070814232107.GA4265@aurum.uhlenkott.net>
 <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
 <46C2BB60.6010909@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 15 2007 10:37, Rene Herman wrote:
> On 08/15/2007 09:28 AM, Jan Engelhardt wrote:
>> On Aug 14 2007 16:21, Jason Uhlenkott wrote:
>
>> > On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:
>> > > NULL is not 0 though.
>> > It is.  Its representation isn't guaranteed to be all-bits-zero,
>> 
>> C guarantees that.
>
> C guarantees what? If you're disagreeing with Jason -- he's right.

http://coding.derkeiler.com/Archive/C_CPP/comp.lang.c/2003-11/1808.html

>> > but the constant value 0 when used in pointer context is always a
>> > null pointer (and in fact the standard requires that NULL be
>> > #defined as 0 or a cast thereof).


	Jan
-- 
