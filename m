Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZLVRge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZLVRge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZLVRgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZLVRgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:36:32 -0500
Message-ID: <4B310374.6060109@redhat.com>
Date: Tue, 22 Dec 2009 19:35:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws> <4B2FA655.6030205@gmail.com> <4B2FAE7B.9030005@codemonkey.ws> <4B2FB3F1.5080808@gmail.com> <4B300EF8.8010602@codemonkey.ws> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <20091222162110.GG10314@basil.fritz.box> <4B30F375.6050103@codemonkey.ws> <20091222173326.GH10314@basil.fritz.box>
In-Reply-To: <20091222173326.GH10314@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 07:33 PM, Andi Kleen wrote:
>> We're not talking about vaporware.  vhost-net exists.
>>      
> Is it as fast as the alacrityvm setup then e.g. for network traffic?
>
> Last I heard the first could do wirespeed 10Gbit/s on standard hardware.
>    

That was with zero-copy IIRC, which is known broken.  There's nothing 
alacrity-specific about zerocopy (and in fact the first zerocopy patches 
were from Rusty).

> Can vhost-net do the same thing?
>    

I've heard unofficial numbers which approach that, but let's wait for 
the official ones.

-- 
error compiling committee.c: too many arguments to function

