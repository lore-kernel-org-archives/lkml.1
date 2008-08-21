Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYHUVZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYHUVZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYHUVYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:24:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbYHUVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:24:55 -0400
Date: Thu, 21 Aug 2008 14:18:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4
 released
In-Reply-To: <48ADD8DE.3010209@goop.org>
Message-ID: <alpine.LFD.1.10.0808211415410.3487@nehalem.linux-foundation.org>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <48AD5A21.7020801@s5r6.in-berlin.de> <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com> <200808212337.38626.nickpiggin@yahoo.com.au> <48ADD8DE.3010209@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Jeremy Fitzhardinge wrote:
>
> "asm volatile" also has no effect on the ordering of the asm with 
> respect to other code; you must use constraints to do that.

Well, the gcc docs at _used_ to say that volatile asms are not moved 
around "significantly". They've removed that.

			Linus
