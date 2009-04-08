Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbZDHL76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbZDHL76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764507AbZDHLjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:39:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58414 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764715AbZDHLi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:38:58 -0400
X-Sasl-enc: irYHG+IseIEC9emEoSNI+SancsQzkgrtQyuQ1a1Pj3qJ 1239190737
Message-ID: <49DC8CCD.8030901@fastmail.fm>
Date: Wed, 08 Apr 2009 12:38:53 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 05/56] block: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080431o3fae1c2es555327578ab06d7@mail.gmail.com>
In-Reply-To: <36ca99e90904080431o3fae1c2es555327578ab06d7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> Could you feed the patches through checkpatch.pl to find and fix these
> style issues.
>
> (...)
>   
> If typeof(c) == CommandList_struct*, that you could replace
> sizeof(CommandList_struct) with sizeof(*c) to make the expression
> shorter and fit into one line.
>   
I was trying to avoid any changes beyond removing the void casts.

I can go through and fix all these if people don't think thats too much to
review in one go.

I'll fix the line issues you've flagged up and resend the affected patched.

Thanks,

Jack
