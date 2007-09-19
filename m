Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbXISFbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbXISFbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbXISFbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:31:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXISFa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:30:59 -0400
Message-ID: <46F0B3F4.10701@zytor.com>
Date: Tue, 18 Sep 2007 22:30:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2 2/2] i386/x86_64 boot: document for 32 bit boot
 protocol
References: <1190171428.12429.63.camel@caritas-dev.intel.com>
In-Reply-To: <1190171428.12429.63.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> Known issues:
> 
> - The hd0_info and hd1_info are deleted from the zero page. Additional
>   work should be done for this? Or this is unnecessary (because no new
>   fields will be added to zero page)?
> 

For backwards compatibility, they should be marked as there for the
short-medium term so we don't reuse them for whatever reason.

	-hpa
