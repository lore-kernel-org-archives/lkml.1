Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbXHOH3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbXHOH3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXHOH24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:28:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59480 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXHOH2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:28:55 -0400
Date: Wed, 15 Aug 2007 09:28:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jason Uhlenkott <jasonuhl@jasonuhl.org>
cc: Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <20070814232107.GA4265@aurum.uhlenkott.net>
Message-ID: <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <20070814232107.GA4265@aurum.uhlenkott.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 14 2007 16:21, Jason Uhlenkott wrote:
>On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:
>> NULL is not 0 though.
>
>It is.  Its representation isn't guaranteed to be all-bits-zero,

C guarantees that.

>but the constant value 0 when used in pointer context is always a
>null pointer (and in fact the standard requires that NULL be
>#defined as 0 or a cast thereof).
>

	Jan
-- 
