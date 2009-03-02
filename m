Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbZCBC5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbZCBC5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZCBC5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:57:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbZCBC5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:57:14 -0500
Message-ID: <49AB4AFC.3010503@redhat.com>
Date: Sun, 01 Mar 2009 21:57:00 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>	 <49AAEC79.3000808@redhat.com>	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>	 <49AB38E7.60305@redhat.com>	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>	 <49AB4171.7000508@kernel.org>	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>	 <49AB4521.8010909@kernel.org> <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In looking at an older (working) kernel a bit more and it looks like 
efi_ioremap() is not called in efi_enter_virtual_mode() pre 2.6.27 on 
this hardware, so we never followed the efi_ioremap codepath up until 
recently. This explains the regression.

Brian
