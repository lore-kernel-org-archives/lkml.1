Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbYDQKuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbYDQKuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbYDQKtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:49:55 -0400
Received: from saeurebad.de ([85.214.36.134]:60636 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYDQKty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:49:54 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [RFC][patch 0/5] Bootmem fixes
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
	<20080417183639.7d3831e0.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 17 Apr 2008 12:49:27 +0200
In-Reply-To: <20080417183639.7d3831e0.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Thu, 17 Apr 2008 18:36:39 +0900")
Message-ID: <87lk3ceoy0.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> On Wed, 16 Apr 2008 13:36:29 +0200
> Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> Hi,
>> 
>> here are a bunch of fixes for the bootmem allocator.  These are tested
>> on boring x86_32 UMA hardware, but 3 patches only show their effects
>> on multi-node systems, so please review and test.
>> 
>> Only the first two patches are real code changes, the others are
>> cleanups.
>> 
>> `Node-setup agnostic free_bootmem()' assumes that all bootmem
>> descriptors describe contiguous regions and bdata_list is in ascending
>> order.  Yinghai was unsure about this fact, Ingo could you ACK/NAK
>> this?
>> 
> Tested on ia64/NUMA box  on 2.6.25. seems no problem.

Cool, thanks a lot!

	Hannes
