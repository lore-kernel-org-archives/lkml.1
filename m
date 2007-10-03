Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXJCO1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXJCO1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbXJCO1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:27:04 -0400
Received: from [122.1.235.145] ([122.1.235.145]:63385 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbXJCO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:27:00 -0400
To: a.p.zijlstra@chello.nl
Cc: kaigai@kaigai.gr.jp, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	<200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	<470395B3.2020904@kaigai.gr.jp>
	<200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
	<1191420442.5599.12.camel@lappy>
In-Reply-To: <1191420442.5599.12.camel@lappy>
Message-Id: <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 23:26:57 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra wrote:
> Also, how do you avoid referencing dead data with your sll? I haven't
> actually looked at your patches, but the simple scheme you outlined
> didn't handle the iteration + concurrent removal scenario:
Regarding my singly-linked list, no entries are removed from the list. It's append only (like CD-R media).
I set is_deleted flag of a entry instead of removing the entry from the list.

Regards.

