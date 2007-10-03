Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXJCNEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXJCNEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXJCNER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:04:17 -0400
Received: from [122.1.235.145] ([122.1.235.145]:64543 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXJCNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:04:16 -0400
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
	<Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
	<200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	<20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	<Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
Message-Id: <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 22:04:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


James Morris wrote:
> I'm pretty sure that the singly linked list idea has been rejected a few 
> times.  Just use the existing API.
Too bad...

Well, is there a way to avoid read_lock when reading list?

Currently, TOMOYO Linux avoids read_lock, on the assumption that
(1) First, ptr->next is initialized with NULL.
(2) Later, ptr->next is assigned non-NULL address.
(3) Assigning to ptr->next is done atomically.

Regards.

