Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab0BQAMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:12:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41424 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933672Ab0BQAMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:12:16 -0500
Message-ID: <4B7B3420.9050105@zytor.com>
Date: Tue, 16 Feb 2010 16:11:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Jean Delvare <khali@linux-fr.org>,
       "lasse.collin@tukaani.org" <lasse.collin@tukaani.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "mirrors@kernel.org" <mirrors@kernel.org>,
       "users@kernel.org" <users@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100212150137.648dca7c@hyperion.delvare>	<4B75A5FE.8020408@zytor.com>	<12c511ca1002122342x6a85459aic31f5c7e8f3786c1@mail.gmail.com>	<4B765F5D.9070106@zytor.com> <20100213095352.361702d0@hyperion.delvare> <4B778D86.5020007@zytor.com> <987664A83D2D224EAE907B061CE93D53123E0ED5@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53123E0ED5@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 09:55 AM, Luck, Tony wrote:
> 
>>> How hard a requirement is this? It might be the right time to
>>> reconsider... Tony's plan may not be perfect but overall I think I like
>>> it.
>>>
>>
>> It's pretty darn hard.  It makes it particularly messy for the mirrors 
>> to ignore it.
> 
> Sometimes hard things are worth the effort though.  I would think that
> there would be considerable advantage to a mirror system that had a
> mechanism to mark entire subtrees as "archive only - no further changes".
> 

There are a couple of reasons to not do that.

a) the moment we do that, some mirrors will start purging those areas.
We have tried to keep our mirror system universally usable by keeping a
"whole mirrors only, please" policy, and it has worked really well so far.

b) it would prevent us from *ever* reorganizing those areas, as many be
required.

c) it complicates a lot of the machinery, including the bits that allow
mirrors to only carry some of the compression formats.  That includes
mirror-side configuration, which I'd really loathe to make anything more
than very simple; mirror admins want things to work as hands-off and
automatic as possible, with a minimum of setup.  Having to learn the
intricacies of each mirror target is just plain hell.

	-hpa

