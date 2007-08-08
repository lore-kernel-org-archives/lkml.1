Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbXHHNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbXHHNaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbXHHNaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:30:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59062 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620AbXHHNaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:30:02 -0400
Date: Wed, 8 Aug 2007 15:30:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Message-ID: <20070808133001.GD14419@one.firstfloor.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com> <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com> <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com> <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you were talking about the general iretq => INTERRUPT_RETURN, then the
> answer is "Yes, they are sufficient". The first version of lguest ran the
> guest kernel in ring 3 (using dual page tables for guest kernel and guest
> user).  The current version I'm pushing runs lguest in ring 1, and the
> entry.S code  worked for both.

How do you implement system calls then? 

-Andi
