Return-Path: <linux-kernel-owner+w=401wt.eu-S1763849AbZE0Hhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763849AbZE0Hhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763032AbZE0Hbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:31:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53378 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763023AbZE0Hbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:31:34 -0400
Date: Wed, 27 May 2009 09:38:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, x86@kernel.org, Huang Ying <ying.huang@intel.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/31] x86: MCE: Fix EIPV behaviour with !PCC
Message-ID: <20090527073809.GU846@one.firstfloor.org>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com> <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com> <4A1CC1E0.2030300@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1CC1E0.2030300@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We never reach there with tolerant == 0.

Fair point. Ying do you remember which test case that fixed?

> 
> And you will remove this code in your 25/31.

I usually kept the earlier patches fixing the code before I remove it, just
in case someone drops the later code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
