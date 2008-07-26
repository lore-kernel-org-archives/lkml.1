Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYGZElc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYGZElc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 00:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYGZElY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 00:41:24 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3387 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYGZElX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 00:41:23 -0400
Message-ID: <488AAAEB.3070005@xs4all.nl>
Date: Sat, 26 Jul 2008 06:41:15 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: What to do with `kswapd0: page allocation failure. ` ?
References: <fa.ajQey35b1AZPlS1/p6joOoTWhU4@ifi.uio.no> <488A214C.3060605@shaw.ca>
In-Reply-To: <488A214C.3060605@shaw.ca>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> It's not really harmful, it just means the kernel was momentarily unable
> to allocate memory to handle an incoming network packet. That packet
> will get dropped, but the system should recover.
> 
> Not sure why it's allocating an order 2 chunk though, that is 16KB. Are
> you using jumbo frames on the network?

Yes. 9000 bytes for GBit LAN.

Udo
