Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0BRT2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab0BRT2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:28:51 -0500
Message-ID: <4B7D94AD.4050504@redhat.com>
Date: Thu, 18 Feb 2010 20:27:41 +0100
From: Michael Stefaniuc <mstefani@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1, fixes
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1266516001-7753-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Frederic!

On 02/18/2010 06:59 PM, Frederic Weisbecker wrote:
> I still can't build the wine tree (even with the wine faq)
> because of the following error:
>
> LD_LIBRARY_PATH="../../libs/wine:$LD_LIBRARY_PATH" ../../tools/wrc/wrc --nostdinc -I. -I. -I../../include -I../../include  -D__WINESRC__ -D_KERNEL32_  -folocale_rc.res locale_rc.rc
> Source: �Q�� a4 51 a4 eb
> Unicode:  5341 6708
> Back: �̤� a2 cc a4 eb
> nls/cht.nls:84:16: Error: String �Q�� does not convert identically to Unicode and back in codepage 950. Try using a Unicode string instead
> make[1]: *** [locale_rc.res] Erreur 1
Wow, what Wine version are you trying to build? That was a known
regression but it was fixed 1-2 days later.

> So I can't test these fixes by myself (although I've tested locally
> with a home made POKEUSER ->  PEEKUSER match test).
>
> Could you please test the following tree? You can pull it on top
> of Linus tree, or clone it.
>
> It's here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
I have just applied your two patches on top of current git. I have run 
the specific test (make exception.ok) as well as full winetest.exe run:
The ptrace regressions impacting Wine are all fixed.

Thanks again for the quick resolution.
bye
         michael
