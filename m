Return-Path: <linux-kernel-owner+w=401wt.eu-S934993AbXHIFXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993AbXHIFXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXHIFWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:22:55 -0400
Received: from gw.goop.org ([64.81.55.164]:47037 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbXHIFWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:22:54 -0400
Message-ID: <46BAA447.9010504@goop.org>
Date: Wed, 08 Aug 2007 22:21:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, Ingo Molnar <mingo@elte.hu>, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in
 entry.S
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com> <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com> <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com> <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com> <20070808133001.GD14419@one.firstfloor.org> <Pine.LNX.4.58.0708080936070.7516@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0708080936070.7516@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 	/*
> 	 * x86 arch doesn't have an easy way to find out where
> 	 * gs is located. So we need to read the MSR. But first
> 	 * we need to save off the rcx, rax and rdx.
>   
Why don't you store it in gs?  movq %gs:my_gs_base, %rax?

    J
