Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYIKXWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYIKXWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYIKXWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:22:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37545 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbYIKXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:22:35 -0400
Message-ID: <48C9A80D.1010703@zytor.com>
Date: Thu, 11 Sep 2008 16:21:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update3] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu>
In-Reply-To: <48C9A6C0.4070802@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
>> There is no reason to include header files conditionally.
>>
>> It might be worthwhile to create a proper subdirectory rather than using
>> an underscored namespace (also, in general, dashes are preferred in
>> filenames.)
> 
> I hate to contradict you, but in that case, lots of other filenames
> would need fixing too:

Not arguing that.  However, in this case I think the right thing is to 
make a subdirectory.

>> Any reason to not just use <linux/compiler.h> here?
> 
> As you may have understood, the decompressors themselves are samples
> and/or reference implementations downloaded from elsewhere, and thus
> might not be up to the coding standards of the rest of the kernel.

I'm familiar with that.  However, I think in this case it is preferrable 
to use the all-kernel facilities, since there is an obvious direct mapping.

	-hpa
