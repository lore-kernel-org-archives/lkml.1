Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZIIVfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZIIVfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZIIVfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:35:51 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:37554 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZIIVfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:35:51 -0400
Message-ID: <4AA81FAA.3090601@t-online.de>
Date: Wed, 09 Sep 2009 23:35:38 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: airlied@linux.ie, linux-kernel@vger.kernel.org,
       ykzhao <yakui.zhao@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after 2.6.31-rc8-git1,
 DVI connector ok
References: <4AA6D858.6040505@t-online.de> <alpine.LFD.2.01.0909081607400.7458@localhost.localdomain> <4AA7549B.5040905@t-online.de> <alpine.LFD.2.01.0909090719070.7458@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909090719070.7458@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-ID: VgeWrcZQQh4Y4h9a05RZ9d4FnwRRILK1AxWfh0jok48nOhMRIbPbC6+F8bGG06jwen
X-TOI-MSGID: e5dccdcd-6cdb-4f59-82a0-f3ebe7e896e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds schrieb:
> On Wed, 9 Sep 2009, Knut Petersen wrote:
>   
>> As the old X does not work with the new kernel, I cannot decide if the 
>> kernel or X is to blame.
>>     
>
> Hmm. Doesn't old X work if you disable KMS? Either with "i915.modeset=0" 
> or by just compiling it out?
>
>   
It does work somehow, but very slow and jerky as long as DRI is
enabled in the kernel.

It´s not a a problem related to KMS. Allocation of tiled buffers fails with
that old X, although it worked with 2.6.22.6, that results in a massive
performance drop (more than 70 percent).

Jerky drawing can only be avoided if DRI is disabled in the kernel.


cu,
 Knut
