Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZFZAkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZFZAkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZFZAke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:40:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:54414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZFZAkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:40:33 -0400
Message-ID: <4A4418EA.9000705@kernel.org>
Date: Fri, 26 Jun 2009 09:40:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org> <4A42C131.6040007@zytor.com> <20090625091939.GS6760@one.firstfloor.org> <4A43871F.9030507@zytor.com> <20090625195408.GW6760@one.firstfloor.org> <4A43DAFD.90409@zytor.com> <20090625202642.GX6760@one.firstfloor.org>
In-Reply-To: <20090625202642.GX6760@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 26 Jun 2009 00:40:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I don't know why, but in the configuration I saw each percpu area was
>> something like 1.8 MB.
> 
> That sounds like something that needs to be investigated and fixed then.
> In a sense per cpu space is precious like stack space and shouldn't 
> be wasted.

The large percpu space is most likely from lockdep.

Thanks.

-- 
tejun
