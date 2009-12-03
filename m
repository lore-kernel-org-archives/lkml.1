Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZLCIdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZLCIdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZLCIds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:33:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZLCIdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:33:47 -0500
Message-ID: <4B177878.2090002@redhat.com>
Date: Thu, 03 Dec 2009 16:36:08 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Joe Peterson <joe@skyrush.com>
Subject: Re: [Patch] tty: move a definition out of switch block
References: <20091201075744.4456.48125.sendpatchset@localhost.localdomain> <20091201154412.4002a0d8@linux.intel.com>
In-Reply-To: <20091201154412.4002a0d8@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 1 Dec 2009 02:54:44 -0500
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> It's not good to leave a definition between 'switch'
>> and its first label. Move it out of the switch block.
> 
> "Not good". On what basis is it not good to put variables local to
> their scope ?
> 

Hello, Alan,

Generally putting variables local in the local scope is fine, but
not for 'switch' block, to be more precisely, not for the case
where putting local variables between 'switch' and its _first_
label, IMO.

It can lead to misunderstanding easily, since 'switch'
jumps to its first label at a first glance. I know in this case
the code is _not_ wrong, but again, it's not good for reading.

Also, there's no conflicts if we put it out of 'switch' block.

Thanks.
