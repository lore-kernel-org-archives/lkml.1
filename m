Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYJMNpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYJMNpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYJMNog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:44:36 -0400
Received: from stinky.trash.net ([213.144.137.162]:37203 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYJMNoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:44:34 -0400
Message-ID: <48F350BF.2090301@trash.net>
Date: Mon, 13 Oct 2008 15:44:31 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nir Tzachar <nir.tzachar@gmail.com>
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
References: <9b2db90b0810101349y7e357ef7g9c53f2ecf19fe3eb@mail.gmail.com> <9b2db90b0810101350o52d79ecka27409bfd3eaf1f8@mail.gmail.com>
In-Reply-To: <9b2db90b0810101350o52d79ecka27409bfd3eaf1f8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nir Tzachar wrote:
> On Fri, Oct 10, 2008 at 10:49 PM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
>>>>> And I always get  the following warning twice:
>>>>>
>>>>> [ 6658.338116] ------------[ cut here ]------------
>>>>> [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
>>>>> nf_nat_fn+0x33/0x155()

>>> Found it - we lost an ifdef during the transition to nf_conntrack
>>> guarding an exception from defragmentation on loopback input.
>>> This patch should fix the warning.
>>
> 
> Yes, the patch below fixes the problem.

Thanks for testing, I've queued the patch for 2.6.28 and -stable.
