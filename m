Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYLPOon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYLPOon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYLPOof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:44:35 -0500
Received: from cmpxchg.org ([85.214.51.133]:59580 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbYLPOof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:44:35 -0500
Date: Tue, 16 Dec 2008 15:46:08 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: time_is_after_jiffies misnomer
Message-ID: <20081216144608.GA19675@cmpxchg.org>
References: <200812161131.mBGBVfV17064@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161131.mBGBVfV17064@inv.it.uc3m.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 12:31:41PM +0100, Peter T. Breuer wrote:
> 
> I thought at first that
> 
>     time_is_after_jiffies(foo)
> 
> meant that the current time is later than foo jiffies.

'foo jiffies'?

It behaves like all the other time_(after|before) macros.  "Compare a
given time T against some other time X".

T is always the first argument to these macros, it's never the current
time.  This is consistent.

And jiffies, the X here, is a well-known global variable. :)

The banner comment above the macro group should have clarified the
misunderstanding, btw.

	Hannes
