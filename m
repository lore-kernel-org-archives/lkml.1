Return-Path: <linux-kernel-owner+w=401wt.eu-S1763590AbXJETWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590AbXJETWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbXJETV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:21:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43768 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXJETV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:21:58 -0400
Date: Fri, 5 Oct 2007 21:21:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <20071005191940.GA4003@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0710052120270.13406@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <20071005191940.GA4003@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 15:19, Lennart Sorensen wrote:
>On Fri, Oct 05, 2007 at 09:13:40PM +0200, Jan Engelhardt wrote:
>> +config VT_PRINTK_COLOR
>> +	hex "Colored kernel message output"
>> +	range 0x00 0xFF
>> +	depends on VT_CONSOLE
>> +	default 0x17
>
>Shouldn't the default at least be what we already had?  Somehow grey on
>blue sounds pretty hard to read to me.

Indeed it should be 0x07, should it go in.
Otherwise the openbsd camp might start another flamewar.

(On a personal note, would 0x1F work better for you?)
