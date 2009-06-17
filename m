Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbZFQNQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbZFQNQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZFQNQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:16:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:50823 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbZFQNQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:16:23 -0400
Message-ID: <4A38EC66.5000504@kernel.org>
Date: Wed, 17 Jun 2009 22:15:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, Paul Mundt <lethal@linux-sh.org>,
       Russell King <rmk@arm.linux.org.uk>, Mikael Starvik <starvik@axis.com>,
       Ralf Baechle <ralf@linux-mips.org>, Bryan Wu <cooloney@kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH 2/9] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1245210060-24344-1-git-send-email-tj@kernel.org>	 <1245210060-24344-3-git-send-email-tj@kernel.org> <1245242459.4503.4.camel@mulgrave.site>
In-Reply-To: <1245242459.4503.4.camel@mulgrave.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 13:15:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-06-17 at 12:40 +0900, Tejun Heo wrote:
>> The following architectures are affected by this change.
>>
>> * sh
>> * arm
>> * cris
>> * mips
>> * sparc(32)
>> * blackfin
>> * avr32
>> * parisc (broken, under investigation)
> 
> I haven't seen anything of this on the parisc list ... what's the
> problem?  and do you need systems or any other help to fix it?

I really don't know what's wrong as nothing should be different from
the old percpu allocator as seen from the arch code.

Kyle reported that the system didn't boot with the patch applied.
Access to a system would be nice but boot debugging usually is done
much easier with local access, so I was hoping he would follow up.
Kyle, do you have any details?

Thanks.

-- 
tejun
