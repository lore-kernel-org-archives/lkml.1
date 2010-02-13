Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab0BMTyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:54:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48029 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944Ab0BMTyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:54:10 -0500
Message-ID: <4B7702FE.7060407@zytor.com>
Date: Sat, 13 Feb 2010 11:52:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 25/35] move round_up/down to kernel.h
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	 <1265793639-15071-26-git-send-email-yinghai@kernel.org> <1266086980.16721.837.camel@Joe-Laptop.home>
In-Reply-To: <1266086980.16721.837.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 10:49 AM, Joe Perches wrote:
> 
> Having both roundup and round_up in kernel.h is a 
> near guarantee for a future incorrect use.
> 
> Can't you use a different name for this?
> 

Welcome to last week's discussion.

Both of these names already exist -- yes, a rename is probably in order
but it should be a separate patchset.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

