Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0APRNR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793Ab0APRNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:13:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab0APRNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:13:15 -0500
Message-ID: <4B51F352.4040803@zytor.com>
Date: Sat, 16 Jan 2010 09:11:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Yuhong Bao <yuhongbao_386@hotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl> <4B511B12.6010208@zytor.com> <20100116123313.GA20059@sucs.org> <alpine.LFD.2.00.1001160753390.5650@localhost>
In-Reply-To: <alpine.LFD.2.00.1001160753390.5650@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 04:57 AM, Robert P. J. Day wrote:
> 
>   actually, it's 896M, not 892M, and i believe it's defined in
> arch/x86/mm/init_32.c:
> 

You also lose an additional small chunk for the fixmap, in addition to
the vmalloc area.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

