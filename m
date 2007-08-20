Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbXHTGPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbXHTGPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 02:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXHTGPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 02:15:23 -0400
Received: from gw.goop.org ([64.81.55.164]:41783 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbXHTGPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 02:15:22 -0400
Message-ID: <46C9317C.2080509@goop.org>
Date: Sun, 19 Aug 2007 23:15:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
 issue
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org> <1187574628.19435.29.camel@localhost.localdomain> <20070820020732.GA3672@sequoia.sous-sol.org>
In-Reply-To: <20070820020732.GA3672@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> That did get backed out (at least the part that broke paravirt patching)
> in 602033ed5907a59ce86f709082a35be047743a86.  Linus' tree should be
> working fine right now with d34fda4a84c18402640a1a2342d6e6d9829e6db7
> committed, and can be further refined with the patch below that's just
> waiting on some further testing.
>   

I don't think this is necessary.  It isn't worth complicating the
interface to avoid the memcpy.

    J
