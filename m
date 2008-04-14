Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYDNMaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYDNMaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYDNMaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:30:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48749 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYDNMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:30:04 -0400
Date: Mon, 14 Apr 2008 14:34:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
Message-ID: <20080414123457.GC18662@one.firstfloor.org>
References: <20080413112308.GA23426@mailshack.com> <87hce5wv2h.fsf@basil.nowhere.org> <1208109831.1489.1247631595@webmail.messagingengine.com> <20080413181642.GA8641@one.firstfloor.org> <1208175845.22460.1247749229@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208175845.22460.1247749229@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Checked with a stock 3.2.3 form gcc.gnu.org (compiled using debian's
> gcc-2.95). It gets it right: places that should get the C version get
> the C version and places that should get the inline-assembly version
> get the inline-assembly version. No funny things at all.

Great. Thanks for testing. Perhaps the problem was limited to 2.9x only.

> B.T.W., debian and ubuntu don't provide gcc-3.2 packages. Is there a
> good reason why gcc-3.2.3 (5 years old in a week) should still be
> supported?

The compiler version is normally only moved up when there is some 
bug in an older version that cannot be reasonably be worked around.
So far 3.2 didn't have anything like this, at least not on x86
(on some other architectures there are problems with older toolkits) 

-Andi
