Return-Path: <linux-kernel-owner+w=401wt.eu-S943381AbXHMPzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943381AbXHMPzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946608AbXHMOP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:15:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45647 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946593AbXHMOP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:15:26 -0400
Date: Mon, 13 Aug 2007 16:15:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: sk malik <srikrishanmalik@yahoo.co.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: why use memcpy when memmove is there?
In-Reply-To: <977159.24669.qm@web7606.mail.in.yahoo.com>
Message-ID: <Pine.LNX.4.64.0708131611400.29571@fbirervta.pbzchgretzou.qr>
References: <977159.24669.qm@web7606.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 13 2007 11:55, sk malik wrote:
>Subject: why use memcpy when memmove is there?

>memcpy copies a part of memory to some other location
>but It will not work for all cases of overlapping
>blocks.(if the start of destination block falls
>between the source block)
>
>while memove copes with overlapping areas.
>
>then why is memcpy present in the sources can't we
>simply do
>
>"#define memcpy memmove" in include/linux/string.h
>
>or am I missing something?

memmove must copy with overlapping memory segments, while memcpy does not, and
can therefore use a different optimization strategy. But that would have been
apparent if you had looked at the code.


	Jan
-- 
