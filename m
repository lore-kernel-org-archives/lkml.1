Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZKQMYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZKQMYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZKQMYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:24:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37496 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbZKQMYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:24:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091117102701.GA16472@infradead.org>
References: <20091117192232.3DF9.A69D9226@jp.fujitsu.com> <20091117102701.GA16472@infradead.org>
Message-Id: <20091117212327.3E08.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 21:24:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 17, 2009 at 07:24:42PM +0900, KOSAKI Motohiro wrote:
> > if xfsbufd doesn't only write out dirty data but also drop page,
> > I agree you. 
> 
> It then drops the reference to the buffer which drops references to the
> pages, which often are the last references, yes.

I though it is not typical case. Am I wrong?
if so, I'm sorry. I'm not XFS expert.



