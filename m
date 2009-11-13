Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZKMIEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZKMIEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZKMIEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:04:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZKMIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:04:46 -0500
Message-ID: <4AFD12F2.2090103@zytor.com>
Date: Fri, 13 Nov 2009 00:04:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
References: <4AF7D820.5040503@kernel.org> <4AFA210B.3020207@kernel.org> <20091112073616.GA11365@elf.ucw.cz> <200911122032.46872.rjw@sisk.pl> <20091113073608.GB26127@elte.hu>
In-Reply-To: <20091113073608.GB26127@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 11:36 PM, Ingo Molnar wrote:
> 
> Physical constraints to allocations (which this is) should be expressed 
> early and with high priority, to make sure they can be met.
> 

Indeed, and in this case this means before bootmem allocator initialization.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

