Return-Path: <linux-kernel-owner+w=401wt.eu-S966176AbXEVWQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966176AbXEVWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXEVWQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:16:15 -0400
Received: from rtr.ca ([64.26.128.89]:3030 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbXEVWQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:16:13 -0400
Message-ID: <46536BA9.5040203@rtr.ca>
Date: Tue, 22 May 2007 18:16:09 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Christian Leber <christian@leber.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] acpi double resume and fail
References: <20070518213701.GA810@core>
In-Reply-To: <20070518213701.GA810@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Leber wrote:
> Hello,
> 
> i hit a problem with suspend to ram and especially resume.
> Hardware: Dell Latitude D810 (some Intel 915 with Intel Pentium M)
> 
> With 2.6.19.7 suspend to ram works reliable, but with 2.6.20-rc4
> it stopped working reliable.
> I still can suspend, but after the first resume it goes back to sleep
> directly again, when resuming again it works.
> After the second suspend it won't resume at all.
> 
> The problem is that i can't try out the kernel versions <rc4, because
> rc1, rc2 and rc3 doesn't boot at all, so git-bisect also won't help.
> 
> Has somebody an idea what i could try out?
> 
> (the distribution is in this case ubuntu feisty)

I had that problem here with Feisty on a Dell i9300 (and on a Dell i9400).
We fixed it by replacing the /etc/acpi/* scripts with my own script.

-ml
