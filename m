Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYDINS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYDINS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYDINSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:18:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39664 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYDINSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:18:48 -0400
Date: Wed, 9 Apr 2008 15:18:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
In-Reply-To: <20080409131420.GL17915@shadowen.org>
Message-ID: <alpine.LNX.1.10.0804091517260.4411@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <87ej9gp6ol.fsf@basil.nowhere.org> <20080409081943.GI17915@shadowen.org> <20080409083013.GJ17915@shadowen.org> <20080409084606.GD19010@one.firstfloor.org>
 <20080409131420.GL17915@shadowen.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-04-09 15:14, Andy Whitcroft wrote:
>On Wed, Apr 09, 2008 at 10:46:06AM +0200, Andi Kleen wrote:
>> > Oh, and if people felt that the concensus was for something to be
>> > implemented and that you are waiting for me to implement the change in
>> > checkpatch; please say so.
>> 
>> Well at least I think the printk change is a good one to implement and there 
>> wasn't much protest to it at least.
>
>Ok.  will put this on my todo list.

Instead of

	if (foo) {
		if (baz) {
			++x;
printk("Oh so long line makes my coding style go wary... nonsensical sentence\n");
		}
	}

I'd keep the indent and allow elongated lines:

	if (foo) {
		if (baz) {
			++x;
			printk("Oh so long line makes my coding style go wary... nonsensical sentence\n");
		}
	}

Or perhaps you just pointed out we need a smarter grep program! :)
