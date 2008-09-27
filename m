Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYI0Rax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYI0Rax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYI0Rao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:30:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:8858 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYI0Ran (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Dd5vuAhDzGPsBFnSmWb4nrBzUADrKOxcRnNVpkGFtgA4y03hglgT/9phkHE5cPIOu5
         EVnLXeTC5W2dYtrcspVkRXGYKt4cGm3oecJoU18RjUNk+2Fx6gYz1inJAa9dr0pUt/6E
         MFvN3NALSAz1jwLc/buzp7AjBWR2gIwtufrqM=
Message-ID: <86802c440809271030w7c96946aw8a38ac853daf8cfa@mail.gmail.com>
Date: Sat, 27 Sep 2008 10:30:42 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: mtrr_cleanup optimization v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080927160936.GA29661@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com>
	 <1222500608-14855-3-git-send-email-yhlu.kernel@gmail.com>
	 <20080927160936.GA29661@elte.hu>
X-Google-Sender-Auth: fada049e7e1b55b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 9:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> fix hpa's t61 with 4g ram
>>    change layout from
>>       (n - 1)*chunksize + chunk_size - NC
>>    to
>>       n*chunksize - NC
>
> applied the three patches to tip/x86/mtrr, thanks Yinghai!
>
> i'm wondering, arent 2/3 and 3/3 also for v2.6.27

let queue to 2.6.28, and later back port to 2.6.27 , 2.6.26 stable

YH
