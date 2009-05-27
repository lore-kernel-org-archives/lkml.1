Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbZE0G7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbZE0G7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760862AbZE0G7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:59:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49430 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760832AbZE0G7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:59:14 -0400
Date: Wed, 27 May 2009 09:05:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 06/31] x86: Fix panic with interrupts off (needed for MCE)
Message-ID: <20090527070547.GP846@one.firstfloor.org>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com> <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com> <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com> <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com> <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com> <4A1CC1EB.3030303@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1CC1EB.3030303@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> #ifdef CONFIG_X86_64
> #define UV_BAU_MESSAGE			0xec
> #endif
> 
> Isn't it?

No, it's not, the ifdef is not needed. I see no point at all in adding 
that ifdef. It would only help if 32bit wanted to add a vector
on its own here which is totally unlikely.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
