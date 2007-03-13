Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXCMRaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXCMRaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXCMRaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:30:13 -0400
Received: from gw.goop.org ([64.81.55.164]:60627 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXCMRaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:30:11 -0400
Message-ID: <45F6DFA2.9060106@goop.org>
Date: Tue, 13 Mar 2007 10:30:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>	<20070313005334.853559ca.akpm@linux-foundation.org>	<45F65ADA.9010501@yahoo.com.au>	<20070313035250.f908a50e.akpm@linux-foundation.org>	<45F685C6.8070806@yahoo.com.au>	<20070313041551.565891b5.akpm@linux-foundation.org>	<45F68B4B.9020200@yahoo.com.au> <20070313044756.b45649ac.akpm@linux-foundation.org> <45F69287.8040509@yahoo.com.au>
In-Reply-To: <45F69287.8040509@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> However we still have to visit those to-be-unmapped parts of the page
> table,
> to find the pages and free them. So we still at least need to bring it
> into
> cache for the read... at which point, the store probably isn't a big
> burden.

Why not try to find a place to stash a linklist pointer and link them
all together?  Saves the pulldown pagetable walk altogether.

    J
