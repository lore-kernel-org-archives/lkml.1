Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZE3GxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZE3GxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 02:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZE3GxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 02:53:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbZE3GxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 02:53:15 -0400
Date: Fri, 29 May 2009 23:53:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: More thoughts about hwpoison and pageflags compression
Message-Id: <20090529235302.ccf58d88.akpm@linux-foundation.org>
In-Reply-To: <20090530063710.GI1065@one.firstfloor.org>
References: <200905291135.124267638@firstfloor.org>
	<20090529225202.0c61a4b3@lxorguk.ukuu.org.uk>
	<20090530063710.GI1065@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 08:37:10 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> So using a separate bit is a sensible choice imho.

Could you make the feature 64-bit-only and use one of bits 32-63?

Did you consider making the poison tag external to the pageframe?  Some
hash(page*) into a bitmap or something?  If suitably designed, such
infrastructure could perhaps be reused to reclaim some existing page
flags.  Dave Hansen had such a patch a few years back.  Or maybe it
was Andy Whitcroft.

