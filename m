Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYIFEH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYIFEH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 00:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYIFEHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 00:07:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYIFEHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 00:07:15 -0400
Message-ID: <48C201E5.7080703@zytor.com>
Date: Fri, 05 Sep 2008 21:07:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes (NOPL issue)
References: <fa.HDZlnwhQIaOU7WkvenWvWDveLiI@ifi.uio.no> <fa.uHa5kqSRJ8gj0H3r9BmGsTqRvFI@ifi.uio.no> <48C200F8.90705@shaw.ca>
In-Reply-To: <48C200F8.90705@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>>
>> if so, should only test on VIA chips.
> 
> The virtual CPUs are more of a problem. They can't be distinguished from 
> the real CPU models they are emulating other than by actually testing.

Right, hence the first-principles test.  In theory we could just execute 
the test on ALL CPUs, but I have excluded family < 6 simply because 
there is a (very) remote possibility one of them might have used that 
opcode for something completely different.

	-hpa
