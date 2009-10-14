Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbZJNWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbZJNWhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbZJNWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:37:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762090AbZJNWhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:37:46 -0400
Message-ID: <4AD6523D.5030909@zytor.com>
Date: Wed, 14 Oct 2009 15:35:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ian Lance Taylor <iant@google.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: linker script syntax nits
References: <20091014221024.EFA79E2F@magilla.sf.frob.com>
In-Reply-To: <20091014221024.EFA79E2F@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 03:10 PM, Roland McGrath wrote:
> The following changes since commit 80f506918fdaaca6b574ba931536a58ce015c7be:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git topic/x86-lds-nits
> 
> Roland McGrath (1):
>       x86: linker script syntax nits
> 
>  arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
>  arch/x86/kernel/vmlinux.lds.S              |   17 ++++++++---------
>  2 files changed, 10 insertions(+), 11 deletions(-)

Severely-Nacked-by: H. Peter Anvin <hpa@zytor.com>

> -	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
>  }
> +
> +ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");

Sinkless asserts are broken in older versions of ld.

	-hpa
