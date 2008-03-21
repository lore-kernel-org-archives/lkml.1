Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbYCUUyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbYCUUyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760380AbYCUUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:53:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47121 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745AbYCUUx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:53:57 -0400
Date: Fri, 21 Mar 2008 21:53:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: relocate_kernel - use predefined PAGE_SIZE
	instead of own alias
Message-ID: <20080321205347.GA3509@elte.hu>
References: <20080321201214.GA9424@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321201214.GA9424@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0451]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch does clean up relocate_kernel_(32|64).S a bit by getting 
> rid of local PAGE_ALIGNED macro. We should use well-known PAGE_SIZE 
> instead

thanks Cyrill, applied.

	Ingo
