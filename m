Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbXHAM4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbXHAM4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbXHAM4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:56:31 -0400
Received: from mail.suse.de ([195.135.220.2]:42861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbXHAM4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:56:31 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/5] x86_64 EFI support -v3: EFI boot support
Date: Wed, 1 Aug 2007 14:56:21 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1185851576.23149.27.camel@caritas-dev.intel.com> <200707311335.40235.ak@suse.de> <1185958748.1363.40.camel@caritas-dev.intel.com>
In-Reply-To: <1185958748.1363.40.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011456.21768.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Should I change "change_page_attr" to make it work before "mem_init"? Or
> Should I change "init_memory_mapping" to make it can be used to change
> mapping attributes? Which one is better?

It's probably better to change init_memory_mapping. Just do it cleanly 
and correctly please. As in only change the pages that straddle the 
EFI areas and don't use globals.

BTW i don't see any such code on i386. How does the EFI support
there handle it?

-Andi
