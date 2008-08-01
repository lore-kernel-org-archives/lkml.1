Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYHAQ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYHAQ2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYHAQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:28:06 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:1769 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYHAQ2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=ZDKqFCHVFgZZ7pa+5LM7n5+QByBR94pMl9Xt9y/PYWQgp4FNW3lN7whRgzDN287Ek4
         q954A3mgWtDiONuOt3cER0KkwJ1KaV/EtvZRy1Vym9Wy6Sx0IIEbRzsQW2ExnvIHS3gQ
         kImpfqkOh2bZgXTIonqlwJwgZ8yNeb5ublnko=
Message-ID: <4893399E.8080503@tuffmail.co.uk>
Date: Fri, 01 Aug 2008 17:28:14 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Jiri Slaby <jirislaby@gmail.com>, tomasw@gmail.com,
       Dave Young <hidave.darkstar@gmail.com>, stable@kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       ath5k-devel@venema.h4ckr.net, johannes@sipsolutions.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k : ath5k_config_interface deadlock
 fix
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>	<4892C359.9000304@cs.helsinki.fi>	<20080801011415.ff4821a3.akpm@linux-foundation.org>	<b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>	<4893257C.1020907@gmail.com> <b6c5339f0808010823o434298ecn7b274c46fe857aba@mail.gmail.com>
In-Reply-To: <b6c5339f0808010823o434298ecn7b274c46fe857aba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland wrote:
> On Fri, Aug 1, 2008 at 11:02 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>   
>>> Not to worry, the commit that introduced it was
>>> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
>>> came in after 2.6.26.
>>>       
>> git-describe 9d139c810a2aa17365cc548d0cd2a189d8433c65
>> v2.6.26-rc8-1219-g9d139c8
>>     
>
> I'm not that expert in git, what does that mean?  Some other commits
> for 2.6.27 also show a 2.6.26-rc from git-describe (e.g. my
> 3a078876caee).
>
> For my own investigation, I did a 'git-checkout v2.6.26' and looked at
> the code to see the patch had not been applied yet.  Is there an
> easier way to definitively say commit X is/is not in tagged release Y?
>
>   

Aha!  I think we want git-describe --contains.

$ git-describe --contains 2b142900784c6e38c8d39fa57d5f95ef08e735d8
v2.6.27-rc1~55^2~1

Alan

