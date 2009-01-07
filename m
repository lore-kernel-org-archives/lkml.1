Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbZAGNgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbZAGNgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbZAGNfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:35:44 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40989 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbZAGNfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:35:42 -0500
Date: Wed, 7 Jan 2009 06:35:40 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090107133540.GS2002@parisc-linux.org>
References: <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com> <1231278275.11687.111.camel@twins> <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain> <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <49642829.20006@cn.fujitsu.com> <1231309970.11687.163.camel@twins> <49645B17.7000001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49645B17.7000001@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 03:34:47PM +0800, Lai Jiangshan wrote:
> So I think current task should sleep earlier when it detects that
> mutex owner start schedule().

How do you propose it detects this?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
