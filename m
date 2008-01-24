Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYAXVNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYAXVNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYAXVMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:12:55 -0500
Received: from gw.goop.org ([64.81.55.164]:59036 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbYAXVMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:12:54 -0500
Message-ID: <4798FF52.30801@goop.org>
Date: Thu, 24 Jan 2008 13:12:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22Oliver_Pinter_=28Pint=E9r_Oliv=E9r=29=22?= 
	<oliver.pntr@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, David Miller <davem@davemloft.net>,
       Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Add common orderly_poweroff() to 2.6.22?
References: <6101e8c40801210959v1e0f6e55w26187dc93a09a202@mail.gmail.com>	 <4798C817.6020702@goop.org>	 <6101e8c40801241033m7347ec5fof8e41c3fe7974feb@mail.gmail.com>	 <4798E26D.6010908@goop.org> <6101e8c40801241228m6026b91bnfcf29c2da3944dfa@mail.gmail.com>
In-Reply-To: <6101e8c40801241228m6026b91bnfcf29c2da3944dfa@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Pinter (Pintér Olivér) wrote:
> the original topic name is : why linux kernel crap ...
>
> the substance is, when from kernel call users-pace program, then come
> up more problems with security...
> when the fs crash out or the userspace code is breaked, then the
> system not shuting down ..
>   

orderly_poweroff() has the option to force a hard shutdown if the exec 
of the usermode command fails.

    J
