Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZETU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZETU2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZETU21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 16:28:27 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44707 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZETU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 16:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IUCYo2mPx6vTSjIFjZSEYWH46a0NyQCoL4rBM4jUikfcXqXMQNX6iSeqZZ6BpaH+33
         S/qS4RT19XuHel2tV3WuOe3xv4BmTU54u7XDWy5WRW9XdCKUbCo5B5n+0VQAU84vgxPP
         F/CvS4o629Virq7tYUwDPMajN54XHyF8rN5/k=
Message-ID: <4A1467E3.1060502@gmail.com>
Date: Wed, 20 May 2009 22:28:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Tobias Doerffel <tobias.doerffel@gmail.com>
CC: linville@tuxdriver.com, mickflemm@gmail.com, lrodriguez@atheros.com,
       me@bobcopeland.com, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ath5k: add support for radio LED
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905202216.43996.tobias.doerffel@gmail.com>
In-Reply-To: <200905202216.43996.tobias.doerffel@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2009 10:16 PM, Tobias Doerffel wrote:
> Hi,
> 
> Am Mittwoch, 20. Mai 2009 22:08:57 schrieb Jiri Slaby:
>> From: Tobias Doerffel <tobias.doerffel@gmail.com>
>>
>> I found these patches on the web not being merged since Jan. Was
>> there any reason why they shouldn't be accepted?
> Yes - they needed further work. The approach was wrong because the GPIO does 
> not control the LED rather than some internal rfkill mechanism (which itself 
> controls the LED). I therefore reworked things to have general RFKILL support 
> in ath5k and proposed the patches. They were reviewed by Bob Copeland and I 
> addressed most of the issues so far but didn't come up with a new patch yet, 
> as there're still minor things to be worked out. If there's interest, I'll 
> prepare a new patch which represents the current state.

I think we are definitely interested. Please send an updated patch.

Thanks.
