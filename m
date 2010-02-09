Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0BIVr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:47:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab0BIVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:47:57 -0500
Message-ID: <4B71D7E2.2020104@zytor.com>
Date: Tue, 09 Feb 2010 13:47:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 15/35] x86: make 64 bit use early_res instead of bootmem
 before slab
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>	<1265743966-17065-16-git-send-email-yinghai@kernel.org> <20100209122632.fc4be9c1.akpm@linux-foundation.org> <4B71D580.805@kernel.org> <4B71D768.4000408@zytor.com>
In-Reply-To: <4B71D768.4000408@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 01:45 PM, H. Peter Anvin wrote:
>>
>> /**
>>  * roundup_pow_of_two - round the given value up to nearest power of two
>>  * @n - parameter
>>  *
> 
> Hah.  Naming can be a real headache with small, common operations.
> 
> At the same time, round_up() versus roundup() is a source of some
> serious confusion.   roundup_bin() might be a better name... I don't know.
> 

On the other hand... if we're doing a renaming patchset at some point
(which would be necessary anyway, since all these interfaces have
users), perhaps we should change roundup_pow_of_two() to
next_power_of_two() or something like that.

	-hpa

