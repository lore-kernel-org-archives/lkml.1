Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYHWUM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYHWUM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYHWUMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:12:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:61656 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYHWUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KlzpqsHQC2fH8ltKUNyw1S4+Txx/k2PFogUn+9bNVPdcTY4sZTeX5jiqOafeeQHT0w
         geOMd+/Tk17OLwAdCdAMSiP4LhMs4rIvvdcKyeucp8pBob1DUlVmncIGUWHgq+p82eq9
         mINFz5i7sEO7c1sZXQU7dPrNTC7iiHUeg4XIw=
Message-ID: <86802c440808231312xba7008en7db5a1aabbbb8418@mail.gmail.com>
Date: Sat, 23 Aug 2008 13:12:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Rufus & Azrael" <rufus-azrael@numericable.fr>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kenrel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <772766.85250.qm@web82102.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <772766.85250.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 12:47 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> please check v2.
>
> Thanks Yinghai.  This still applies to a different line number in
> v2.6.27-rc4 than what the patch indicates.  I also get a warning
> about unused variable "i" (I commented it out in my previous fix,
> but not this time).
>
> At any rate, I still produces a kernel that hangs at the typical
> location.
>
dmesg and lspci -vvxxx with hpet=disable?

please boot with "debug initcall_debug hpet=disable"

YH
