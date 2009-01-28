Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZA1XC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZA1XC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZA1XCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:02:49 -0500
Received: from main.gmane.org ([80.91.229.2]:40292 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZA1XCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:02:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
Date: Wed, 28 Jan 2009 15:04:07 -0800
Message-ID: <873af36niw.fsf@blp.benpfaff.org>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <1233106614.3256.6.camel@localhost.localdomain> <200901281337.52294.arnd@arndb.de> <49809A65.2090501@kernel.org> <1233170532.6717.49.camel@brick> <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain> <1233172994.6717.56.camel@brick> <4980CD51.70601@zytor.com> <1233179884.6717.59.camel@brick> <4980D913.3000505@zytor.com> <1233182314.6717.66.camel@brick>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-75-36-168-230.dsl.pltn13.sbcglobal.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:/psV8p3TFTsQsU9RXoDMcUQzJtQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> writes:

> Is there a byteswap builtin in gcc?  At least AVR32
> seems to use it, but perhaps it's not generally exposed...perhaps we
> could ask the gcc-folk?

Yes, GCC has byteswap builtins on x86 documented as follows:

 -- Built-in Function: int32_t __builtin_bswap32 (int32_t x)
     Returns X with the order of the bytes reversed; for example,
     `0xaabbccdd' becomes `0xddccbbaa'.  Byte here always means exactly
     8 bits.

 -- Built-in Function: int64_t __builtin_bswap64 (int64_t x)
     Similar to `__builtin_bswap32', except the argument and return
     types are 64-bit.

These were only added as of GCC 4.3 though.
-- 
Ben Pfaff 
http://benpfaff.org

