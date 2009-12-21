Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZLUTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZLUTJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZLUTJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:09:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49672 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988AbZLUTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:09:40 -0500
Message-ID: <4B2FC7E6.5030508@zytor.com>
Date: Mon, 21 Dec 2009 11:09:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Michael Tokarev <mjt@tls.msk.ru>, Michal Marek <mmarek@suse.cz>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
 boot
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org> <4B2E084D.6080105@msgid.tls.msk.ru> <20091220141156.GA3744@merkur.ravnborg.org> <4B2FBE69.3080408@zytor.com>
In-Reply-To: <4B2FBE69.3080408@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 10:28 AM, H. Peter Anvin wrote:
> On 12/20/2009 06:11 AM, Sam Ravnborg wrote:
>>
>> The whole business using shell scripts to append the size seems broken.
>> How about moving this functionality to mkpiggy where we are
>> less shell script dependent.
>>
> 
> Seems a helluva lot saner to me...
> 
>> It includes the length also in the gzip case - I dunno if that matters.
>> Also I dunno if ".long" is the same on 32 and 64 bit.
> 
> Well, gzip already has a length at the end... shouldn't really hurt
> anything, I suppose.  ".long" is 32 bits on both 32 and 64 bits.
> 

Note, though: mkpiggy is x86, but this also affects other
architectures... so probably additional changes are needed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

