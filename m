Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZFKRvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZFKRvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZFKRvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:51:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:51766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbZFKRvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:51:08 -0400
Message-ID: <4A3143E3.3090705@kernel.org>
Date: Thu, 11 Jun 2009 10:50:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mingo@elte.hu, mpm@selenic.com, npiggin@suse.de
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>	 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>	 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>	 <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>	 <alpine.DEB.1.10.0906110954030.29827@gentwo.org>	 <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com> <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com>
In-Reply-To: <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Christoph,
> 
> On Thu, Jun 11, 2009 at 5:06 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
>> I have not tested hotplug and cpuset_init_early() does indeed needs to
>> be switched over to slab (it does that via fallback now).
> 
> Oh, my bad, Yinghai took care of cpusets too:

your trees works here here. numa and SLUB

YH
