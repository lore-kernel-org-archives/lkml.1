Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYGIU1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYGIU1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYGIU1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:27:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46563 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYGIU1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:27:35 -0400
Date: Wed, 9 Jul 2008 23:26:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709202633.GC14386@cs181140183.pp.htv.fi>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org> <4874FEDF.90404@sgi.com> <20080709193404.GC4804@elte.hu> <48751533.7030602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48751533.7030602@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 03:44:51PM -0400, H. Peter Anvin wrote:
> Ingo Molnar wrote:
>>
>> the problem is, we cannot just put it even into tip/master if there's 
>> no short-term hope of fixing a problem it triggers. gcc-4.2.3 is solid 
>> for me otherwise, for series of thousands of randomly built kernels.
>>
>
> 4.2.3 is fine; he was using 4.2.0 before, and as far as I know, 4.2.0  
> and 4.2.1 are known broken for the kernel.

Not sure where your knowledge comes from, but the ones I try to get 
blacklisted due to known gcc bugs are 4.1.0 and 4.1.1.

On a larger picture, we officially support gcc >= 3.2, and if any kernel 
change triggers a bug with e.g. gcc 3.2.3 that's technically a 
regression in the kernel...

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

