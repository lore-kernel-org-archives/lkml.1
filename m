Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0BIWpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:45:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43005 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0BIWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:45:10 -0500
Message-ID: <4B71E54B.5070507@zytor.com>
Date: Tue, 09 Feb 2010 14:44:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 15/35] x86: make 64 bit use early_res instead of bootmem
 before slab
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>	<1265743966-17065-16-git-send-email-yinghai@kernel.org>	<20100209122632.fc4be9c1.akpm@linux-foundation.org>	<4B71D580.805@kernel.org> <20100209143307.86184916.akpm@linux-foundation.org>
In-Reply-To: <20100209143307.86184916.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 02:33 PM, Andrew Morton wrote:
> 
> err, crap, yeah.
> 
> It would be nice to fix all this up, and get the private round_up()
> stuff out of x86 and into kernel.h.
> 
> The present naming scheme is ghastly:
> 
> ALIGN
> DIV_ROUND_UP
> roundup
> round_up
> round_down
> 
> Where round_up and ALIGN are kinda maybe the same.
> 

Yes indeed.  It seems to be something for a separate patchset, though,
since it will touch stuff across a lot of code.

	-hpa

