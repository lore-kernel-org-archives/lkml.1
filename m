Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbXIQPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbXIQPa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbXIQPav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:30:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbXIQPau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:30:50 -0400
Message-ID: <46EE9D94.9030608@zytor.com>
Date: Mon, 17 Sep 2007 08:30:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC -mm 1/2] i386/x86_64 boot: setup data
References: <1190017578.5866.21.camel@caritas-dev.intel.com>
In-Reply-To: <1190017578.5866.21.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch add a field of 64-bit physical pointer to NULL terminated
> single linked list of struct setup_data to real-mode kernel
> header. This is used to define a more extensible boot parameters
> passing mechanism.

You MUST NOT add a field like this without changing the version number,
and, since you expect to enter the kernel at the PM entrypoint, you
better *CHECK* that version number before ever descending down the chain.

	-hpa
