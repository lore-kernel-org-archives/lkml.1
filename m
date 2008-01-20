Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYATUlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYATUlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYATUlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:41:36 -0500
Received: from mail.labdns.net ([68.142.129.33]:52194 "HELO mail.labdns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752484AbYATUlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:41:35 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 15:41:35 EST
Message-ID: <4793B025.2060701@infoplatter.com>
Date: Sun, 20 Jan 2008 13:33:41 -0700
From: Charles Johnston <charles@infoplatter.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephan von Krawczynski <skraw@ithnet.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem with tg3 in 2.6.23.12
References: <20080113150407.d2ca967b.skraw@ithnet.com> <20080120144713.880701d2.skraw@ithnet.com>
In-Reply-To: <20080120144713.880701d2.skraw@ithnet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan von Krawczynski wrote:
> On Sun, 13 Jan 2008 15:04:07 +0100
> Stephan von Krawczynski <skraw@ithnet.com> wrote:
> 
>> Hello all,
>>
>> we recently tried to stress several netblk configurations and got this kernel
>> log (amongst others). If additional information is required feel free to ask. We can try patches as well the config is not in production yet.
> 
> Does anybody have an idea what my original posting is all about?
> 

I might have some idea.  From your lspci, it looks like a board I had some 
issues with about one year ago.  It was a Tyan server board that I had put a 
3ware card into a pci-X 133MHz slot.  Well, for some reason, the Broadcom 
chip would have trouble, bad data, kernel problems like yours.  I called 
Tyan and they had me short a jumper that forced the slot to 100MHz (the bus 
is shared between that slot and the Broadcom chip) and that fixed it for me.

I hope that might be some help to you.


Good luck,
Charles
