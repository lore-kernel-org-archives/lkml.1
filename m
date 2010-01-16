Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab0APBt2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 20:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660Ab0APBt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 20:49:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab0APBt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 20:49:27 -0500
Message-ID: <4B511B12.6010208@zytor.com>
Date: Fri, 15 Jan 2010 17:49:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
In-Reply-To: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 05:29 PM, Yuhong Bao wrote:
> 
> Given that Linus was once talking about the performance penalties of PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of interest:
> http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
> 

The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
(PAE), it's between HIGHMEM and !HIGHMEM.  That cutoff is ~892 MB for a
stock 32-bit kernel.

	-hpa
