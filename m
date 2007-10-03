Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbXJCOb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbXJCOb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXJCObu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:31:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38740 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbXJCObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:31:49 -0400
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kaigai@kaigai.gr.jp, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
In-Reply-To: <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
References: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	 <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	 <470395B3.2020904@kaigai.gr.jp>
	 <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
	 <1191420442.5599.12.camel@lappy>
	 <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 16:26:04 +0200
Message-Id: <1191421564.5599.14.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-03 at 23:26 +0900, Tetsuo Handa wrote:
> Peter Zijlstra wrote:
> > Also, how do you avoid referencing dead data with your sll? I haven't
> > actually looked at your patches, but the simple scheme you outlined
> > didn't handle the iteration + concurrent removal scenario:

> Regarding my singly-linked list, no entries are removed from the list. It's append only (like CD-R media).
> I set is_deleted flag of a entry instead of removing the entry from the list.

sounds like a might fine memory leak / dos attack.

