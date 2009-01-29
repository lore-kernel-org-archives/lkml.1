Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbZA2WbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbZA2WbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbZA2Wav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:30:51 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55967 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760047AbZA2Wat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:30:49 -0500
Message-ID: <49822E0D.2070607@euromail.se>
Date: Thu, 29 Jan 2009 23:30:37 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] input: bcm5974: Prepare for a new trackpad header
 type
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>	<1233138229-12489-2-git-send-email-rydberg@euromail.se> <20090129003321.e9c8c36c.akpm@linux-foundation.org>
In-Reply-To: <20090129003321.e9c8c36c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LSfPL-0002Ah-6t.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LSfPL-0002Ah-6t 35660b8a268bb8b3a6157aaeaefabbd5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 28 Jan 2009 11:23:44 +0100 "Henrik Rydberg" <rydberg@euromail.se> wrote:

Thanks for taking care of the patches, and for spotting the surplus
patches 5/6 and 6/6 - my mistake.

>> +	f = (const struct tp_finger *)(dev->tp_data + c->tp_offset);
> 
> Is there anything which guarantees that `f' is sufficiently aligned? 
> If not, the code might cause unaligned exceptions on some
> architectures?
> 

I believe it is - I will send a patch in reply to this message that
ought to make it clearer.

Thanks,
Henrik
