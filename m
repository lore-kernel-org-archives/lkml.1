Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0BOTHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:07:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58627 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab0BOTHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:07:53 -0500
Message-ID: <4B799B74.8050908@zytor.com>
Date: Mon, 15 Feb 2010 11:07:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
References: <20100215161752.GA19962@redhat.com>
In-Reply-To: <20100215161752.GA19962@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 08:17 AM, Oleg Nesterov wrote:
>> +void set_personality_ia32(void);
>> +#define COMPAT_SET_PERSONALITY(ex) set_personality_ia32()
> 
> OK, but what about force_personality32? With this patch it becomes
> unused?

This is a bug... I happened not to notice it before on my system
force_personality32 is zero.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

