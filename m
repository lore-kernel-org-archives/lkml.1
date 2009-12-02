Return-Path: <linux-kernel-owner+w=401wt.eu-S1751481AbZLBFlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbZLBFlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZLBFlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:41:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:42495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZLBFlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:41:04 -0500
Message-ID: <4B15FDCD.7040401@kernel.org>
Date: Wed, 02 Dec 2009 14:40:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: michal.simek@petalogix.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>	<4B14D6E2.2040704@petalogix.com> <20091201210343.f0a1d353.sfr@canb.auug.org.au>
In-Reply-To: <20091201210343.f0a1d353.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/01/2009 07:03 PM, Stephen Rothwell wrote:
> cc'ing the percpu and workqueue folks ...
> 
> On Tue, 01 Dec 2009 09:42:10 +0100 Michal Simek <michal.simek@petalogix.com> wrote:
>>
>> It seems to me that percpu has more other troubles too.
>> Look at boolog below for Microblaze with MMU.
> 
> Or may the workqueue additions?

The wq changes need to be rebased due to scheduler related bits.  I'm
backing them out for now.  I'll fix this problem before pushing the
series out again.

Thanks.

-- 
tejun
