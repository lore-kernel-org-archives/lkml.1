Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZIYLqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZIYLqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZIYLqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:46:52 -0400
Received: from mail.crca.org.au ([67.207.131.56]:56021 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZIYLqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:46:51 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4ABCADCB.1080801@crca.org.au>
Date: Fri, 25 Sep 2009 21:47:23 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: No more bits in vm_area_struct's vm_flags.
References: <4AB9A0D6.1090004@crca.org.au> <Pine.LNX.4.64.0909232056020.3360@sister.anvils> <4ABC7FBC.4050409@crca.org.au> <Pine.LNX.4.64.0909251225150.7496@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909251225150.7496@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Hugh Dickins wrote:
> On Fri, 25 Sep 2009, Nigel Cunningham wrote:
>> Hugh Dickins wrote:
>>> Does TuxOnIce rely on CONFIG_MMU?  If so, then the TuxOnIce patch
>>> could presumably reuse VM_MAPPED_COPY for now - but don't be
>>> surprised if that's one we clean away later on.
>> Hmm. I'm not sure. The requirements are the same as for swsusp and
>> uswsusp. Is there some tool to graph config dependencies?
> 
> If its requirements are the same as theirs, then I think yes,
> TuxOnIce relies on  config MMU: because config HIBERNATION depends
> on SWAP (kernel/power/Kconfig) and config SWAP depends on MMU
> (init/Kconfig).
> 
> But I hesitated to assume that, because in the TuxOnIce patch I have
> here for reference (e.g. when deciding it'll cause you unwelcome hassle
> if I move swap_info_struct from swap.h to swapfile.c!), it looked as if
> you support saving to an ordinary file, not just to a swap file?

Yes, that's right.

>> Is there some tool to graph config dependencies?
> 
> I don't know it, but would be nice, and maybe it does exist.

Okee doke.

Nigel
