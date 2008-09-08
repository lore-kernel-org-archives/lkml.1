Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYIHRmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYIHRmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYIHRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:42:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbYIHRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:42:03 -0400
Date: Mon, 8 Sep 2008 10:41:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <48C55CEC.1080900@kernel.org>
Message-ID: <alpine.LFD.1.10.0809081038500.3117@nehalem.linux-foundation.org>
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org>
 <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org>
 <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org> <48C55C0A.7070203@zytor.com> <48C55CEC.1080900@kernel.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, H. Peter Anvin wrote:
> 
> I should point out that the code above is from binutils (gas), not from gcc.

Doesn't matter. If gcc passes "-mtune=i686" down to gas and thus the end 
result doesn't match gcc's own documentation (and whole point of -mtune), 
then it's still a gcc bug, even if it may not be a "cc1" bug. The fact 
that "cc1" and "gas" are two different phases is pretty much irrelevant. 
gcc calls them both.

But sure, if there are separate bugzillas, post it in both. 

			Linus
