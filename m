Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZI3Xqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZI3Xqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZI3Xqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:46:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58975 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbZI3Xqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:46:32 -0400
Message-ID: <4AC3ED9D.6030701@zytor.com>
Date: Wed, 30 Sep 2009 16:45:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, samuel.thibault@ens-lyon.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       andi@firstfloor.org, netdev@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] Fix csum_ipv6_magic asm memory clobber
References: <4AC3DF7B.5060407@zytor.com>	<20090930230138.GZ6451@const.famille.thibault.fr>	<20090930161939.8c6d140a.akpm@linux-foundation.org> <20090930.162233.208543104.davem@davemloft.net>
In-Reply-To: <20090930.162233.208543104.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 04:22 PM, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 30 Sep 2009 16:19:39 -0700
> 
>> From: Samuel Thibault <samuel.thibault@ens-lyon.org>
>>
>> Just like ip_fast_csum, the assembly snippet in csum_ipv6_magic needs a
>> memory clobber, as it is only passed the address of the buffer, not a
>> memory reference to the buffer itself.
>>
>> This caused failures in Hurd's pfinetv4 when we tried to compile it with
>> gcc-4.3 (bogus checksums).
>>
>> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> I'm happy to see this go in via the x86 tree, and thus:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

I'll put it in x86/urgent tonight or early tomorrow morning (just about
to leave for the airport.)

	-hpa

