Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYFCLKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYFCLKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYFCLJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:09:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35569 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYFCLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:09:57 -0400
Date: Tue, 3 Jun 2008 13:09:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nick Piggin <npiggin@suse.de>
cc: Petr Tesarik <ptesarik@suse.cz>, Christoph Hellwig <hch@lst.de>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Why is the rewritten ramdisk driver called brd instad of rd
In-Reply-To: <20080528061130.GB16441@wotan.suse.de>
Message-ID: <alpine.LNX.1.10.0806031309350.4055@fbirervta.pbzchgretzou.qr>
References: <20080321130552.GA28274@lst.de> <1211880480.29836.11.camel@elijah.suse.cz> <20080528061130.GB16441@wotan.suse.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-28 08:11, Nick Piggin wrote:

>On Tue, May 27, 2008 at 11:28:00AM +0200, Petr Tesarik wrote:
>> On Fri, 2008-03-21 at 14:05 +0100, Christoph Hellwig wrote:
>> > Any reason why the rewritten ramdisk driver has a new name?  It's for
>> > all matters an inplace replacement of the old rd driver so it should
>> > be called rd.c / rd.ko to not confused instaler/developers/etc.
>> 
>> I think it's because the old rd played some dirty tricks with the page
>> cache, while the reworked one is a straightforward implementation of a
>> normal _b_lock device -> hence the "b".
>> 
>> No guarantee of correctness.
>
>Yeah it was a rwrite from scratch and it lived with the rd.c code for
>a while (although maybe never in mainline). I guess it might be good
>idea to rename it back to rd?

Just add a MODULE_ALIAS("rd").

