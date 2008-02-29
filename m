Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbYB2X1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbYB2X1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbYB2X1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:27:24 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:36950 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYB2X1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:27:23 -0500
Date: Sat, 1 Mar 2008 00:27:22 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: linux-kernel@vger.kernel.org
Subject: Re: Few ideas...
In-Reply-To: <m3fxvb9wuh.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0803010018050.24056@fbirervta.pbzchgretzou.qr>
References: <m3od9z9y6t.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0803010004350.24056@fbirervta.pbzchgretzou.qr>
 <m3fxvb9wuh.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 1 2008 00:17, Krzysztof Halasa wrote:
>
>> d: I think it would not bad if it were included in the resulting
>> object file like MODULE_AUTHOR is.
>
>I specifically don't want it in the binary - maintainers change, it's
>not a point of contact for end users. It would be for source code ops
>only.

So what apart from the parsability of a MODULE_MAINTAINER() tag,
what is different from authors engraving their name into a
comment at the start of the .c file?

>> If anything, MODULE_AUTHOR could be removed, because the original
>> author(s) are usually listed at the top of the .c file and not
>> always the ones to talk to when there is a bug (=> the maintainer
>> is).
>
>Perhaps it's there because of copyright.

A number of .c files (even those that are not just built-in, but can
also be built as =m) do not have a MODULE_AUTHOR(); and copyright is
even valid when there is no apparent author name.
