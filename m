Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYEIW7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYEIW7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbYEIW7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:59:44 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44562 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbYEIW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:59:43 -0400
Message-ID: <4824D79C.7060303@keyaccess.nl>
Date: Sat, 10 May 2008 01:00:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Takashi Iwai <tiwai@suse.de>, Glauber Costa <gcosta@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de> <48243D86.7020504@keyaccess.nl> <20080509122828.GB10855@elte.hu>
In-Reply-To: <20080509122828.GB10855@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-05-08 14:28, Ingo Molnar wrote:
> * Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 09-05-08 08:06, Takashi Iwai wrote:
>>
>>> Thanks for catching it.  Yeah, the patch looks buggy.  We had an
>>> implicit assumption that dev = NULL for ISA devices that require 24bit
>>> DMA.
>>>
>>> How about the patch below?  It's against the latest Linus git tree.
>> Yes, works well. Thank you.
> 
> great, thanks Rene for catching this! Added this line to the patch as 
> well:
> 
>  Tested-by: Rene Herman <rene.herman@keyaccess.nl>

Oh... it was rather significantly in the AM when I posted so I forgot to
mention in the haste to get this out of the way but it was Pete Clements
who reported the regression:

http://www.nabble.com/Lost-Sound-from-2.6.24-to-2.6.25----CS4236-ISA-tc17062547.html

He also tested it, so as long as we're name-mention-flattering around...

And this a good excuse to ask how you edit changelog after the fact. Just
reset/reapply and stuff or is there a "better" way? I fairly frequently
find myself wanting to do just that but it's a bit of a mess when there's
already commits on top.

Rene.

