Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070Ab0AVRuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0AVRuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056Ab0AVRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:50:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32991 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab0AVRuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:50:03 -0500
Message-ID: <4B59E507.9060403@zytor.com>
Date: Fri, 22 Jan 2010 09:48:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable fixes
References: <1264172467-25155-1-git-send-email-bp@amd64.org> <4B59DF4C.7040608@zytor.com> <20100122174049.GC19425@aftab>
In-Reply-To: <20100122174049.GC19425@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2010 09:40 AM, Borislav Petkov wrote:
>>>
>>> Those patches are also good -stable candidates.
>>
>> Hmmm... I'm not sure I see a strong justification for a late -rc push
>> into Linus/stable push for for these... I think you would have to
>> explicitly make the case if you want them to be considered as such.
> 
> Well, on the one hand, they fix real bugs in the L3 cache index disable
> code and since they're bugfixes, they are eligible late -rc candidates.
> 

Bugfixes are *early* -rc candidates.  Regression fixes are *late* -rc
candidates, at least that seems to be the policy Linus currently
implements.  -stable seems to use slightly less strict criteria (the
whole point is that -final needs to be a stabilization point, backported
fixes/drivers can then come onto a stable base) which is why you seem
some patches which are "straight to .1".

> On the other hand, however and more importantly, the machines which
> have that feature are not selling yet so postponing the patches for the
> next merge window is still ok. I'll backport them then to .32 for the
> distro kernels and .33 and I think we are going to be fine this way.
> 
> So queueing them for .34 is still fine with me, thanks.

OK.  You can check with -stable if they want to take the backport post-.33.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

