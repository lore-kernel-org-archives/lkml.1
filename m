Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYJAGrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYJAGrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYJAGq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:46:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYJAGq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WekX+38b+ruotbDcjA2CpMMkHKyIw+xgDTtBOrN2CGsTui8Ro0SYmuXK1QS+Owtulq
         AogDnQz42OSAxgaawvqM/KHiWmuyq3hAD6ZBDLA6fwDxs0P5OJwY0HnFB5B1GodutR+e
         LvK1XE8wN7rvVqdRzZbBd17w5x75P2rsICNFw=
Message-ID: <86802c440809302346h28dfb83fif1436e63fd819b7a@mail.gmail.com>
Date: Tue, 30 Sep 2008 23:46:54 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: change MTRR_SANITIZER to def_bool y
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081001063632.GA30756@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	 <1222817380-29481-3-git-send-email-yhlu.kernel@gmail.com>
	 <20081001063632.GA30756@elte.hu>
X-Google-Sender-Auth: b1b689bdcaeec7cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 11:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  arch/x86/Kconfig |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> applied the patch below to tip/x86/mtrr, thanks Yinghai!
>
> (i'll wait for v2 of the mtrr parameter documentation patches.)

mtrr-cleanup-debug, mtrr-clearnup, nomtrr-cleanup  - v2 the 1/3 and
2/3 in series...
or
mtrr_cleanup_debug, mtrr_clearnup, nomtrr_cleanup -V?
or
mtrrcleanup_debug, mtrrclearnup, nomtrrcleanup -v1

which one should we use ?

YH
