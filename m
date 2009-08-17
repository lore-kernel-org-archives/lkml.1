Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZHQN2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZHQN2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZHQN2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:28:32 -0400
Received: from mga12.intel.com ([143.182.124.36]:33087 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbZHQN2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:28:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,396,1246863600"; 
   d="scan'208";a="176553170"
Message-ID: <4A895AFB.9090302@linux.intel.com>
Date: Mon, 17 Aug 2009 15:28:27 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86, mce: Don't initialize MCEs on unknown CPUs
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com> <20090817112938.GA22794@elte.hu> <4A89409B.8020103@linux.intel.com> <20090817115341.GA13895@elte.hu>
In-Reply-To: <20090817115341.GA13895@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Not really, we dont re-run mce_cap_init() if MCE is disabled so 
> there's no memory leak that would fill all memory.

True.

-Andi
