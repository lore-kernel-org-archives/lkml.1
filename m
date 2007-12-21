Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbXLUDtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbXLUDtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXLUDtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:49:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbXLUDta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:49:30 -0500
Date: Thu, 20 Dec 2007 19:49:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>, Junio C Hamano <gitster@pobox.com>,
       Git Mailing List <git@vger.kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
In-Reply-To: <20071221030152.GC8535@fattire.cabal.ca>
Message-ID: <alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org> <20071221024805.GB8535@fattire.cabal.ca> <20071221030152.GC8535@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Dec 2007, Kyle McMartin wrote:
> 
> I think I see the problem, it's lack of context in the diff,

No, the problem is that "git diff" is apparently broken by a recent 
optimization. The diff is simply broken.

The tar-ball and the git archive itself is fine, but yes, the diff from 
2.6.23 to 2.6.24-rc6 is bad. It's the "trim_common_tail()" optimization 
that has caused way too much pain.

Sorry about that, I'll fix it up asap.

		Linus
