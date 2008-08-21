Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYHUQ0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYHUQ0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYHUQZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:25:51 -0400
Received: from gw.goop.org ([64.81.55.164]:36136 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbYHUQZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:25:50 -0400
Message-ID: <48AD970D.40209@goop.org>
Date: Thu, 21 Aug 2008 09:25:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: export pv_lock_ops non-GPL
References: <48AC62EB.6060804@goop.org> <20080821091051.GA1683@elte.hu>
In-Reply-To: <20080821091051.GA1683@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> uhm, why is this even a question? All of this stuff is so deep inside 
> the guts of the kernel ... so nope - if then we want to change the 
> others to _GPL exports as well, just to make sure nobody gets funny 
> ideas.

pv_lock_ops gets accessed by inline functions which get inlined into
modules.  They should never directly access it, but the generated code
will.  _spin_lock() is in exactly the same situation.

    J

