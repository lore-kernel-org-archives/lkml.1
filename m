Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXJCOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXJCOid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbXJCOiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:38:22 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35010 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbXJCOiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:38:20 -0400
Date: Wed, 3 Oct 2007 16:37:54 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: a.p.zijlstra@chello.nl, kaigai@kaigai.gr.jp, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
In-Reply-To: <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
Message-ID: <Pine.LNX.4.64.0710031635470.1310@twin.jikos.cz>
References: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
 <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
 <470395B3.2020904@kaigai.gr.jp> <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
 <1191420442.5599.12.camel@lappy> <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007, Tetsuo Handa wrote:

> Regarding my singly-linked list, no entries are removed from the list. 
> It's append only (like CD-R media). I set is_deleted flag of a entry 
> instead of removing the entry from the list.

Why so? 

This smells like a horrible leaking of memory. How fast can the list grow 
during the lifetime of the system?

-- 
Jiri Kosina
