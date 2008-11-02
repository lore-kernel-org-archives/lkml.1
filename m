Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYKBCgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYKBCgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYKBCgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:36:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3873 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752545AbYKBCgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:36:32 -0400
Date: Sat, 1 Nov 2008 22:36:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: (BUG?) round_jiffies() is non-monotonic on SMP
In-Reply-To: <20081101131648.398fe54a@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0811012234590.30060-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, Arjan van de Ven wrote:

> > Come to think of it, is there any good reason why round_jiffies()  
> > doesn't always round up?  It seems a lot safer.
> 
> at the time folks had concerns about making a big error in that
> direction...

All right then.  Would it be preferable to add a new round_jiffies_up() 
routine, or to change round_jiffies() so that it never rounds down?

Alan Stern

