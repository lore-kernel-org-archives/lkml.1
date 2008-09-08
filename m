Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbYIHBsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbYIHBsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYIHBsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 21:48:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYIHBsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:48:42 -0400
Message-ID: <48C48467.40703@zytor.com>
Date: Sun, 07 Sep 2008 18:48:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <48C1C156.9080003@zytor.com> <200809071607.52645.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net>
In-Reply-To: <200809071922.32974.linux@sandersweb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Sanders wrote:
> 
> Yes the patch you supplied (and now in Linus's tree) fixes (part) of the problem.
> In order to get a working kernel I also need a patch for the nops.h issue.  
> I have tested and confirmed that the patch posted by Linus works and finally 
> solves the problem with virtual PC.
> 
> Linus please apply your patch (which I quote below).

No, please don't.  Instead, David, please enable CONFIG_X86_GENERIC.

	-hpa
