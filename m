Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZGGG5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZGGG5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZGGG5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:57:35 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34201 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZGGG5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hL+MmVIbe5+gJ2iVUMTRYgVdMotuXE2H8Qsm/QniNTTzsdhOQ3sIjYDCZ+0l4lG2bQ
         oMrtQQ31kCHrvaau8KlbeSImlHLKphdif1ws/ZISOjdUwXSVVMEAxJwiOzXeGHI/85Iq
         RktHqwLJ72Bn+lDdAx3mW0GgZ2x08SL/loXjs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907062302540.10840@chino.kir.corp.google.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	 <bXZeuxPQAWE.A.Y2.2BpUKB@chimera> <4A529F60.7010509@lwfinger.net>
	 <alpine.DEB.2.00.0907062302540.10840@chino.kir.corp.google.com>
Date: Tue, 7 Jul 2009 09:57:36 +0300
X-Google-Sender-Auth: 2a7b2b02169fe808
Message-ID: <84144f020907062357m6a75d2eav1589e7f8b4a3d887@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 6 Jul 2009, Larry Finger wrote:
>> I have not seen the fix yet, but one is being prepared. I think the
>> bug can be closed.

On Tue, Jul 7, 2009 at 9:29 AM, David Rientjes<rientjes@google.com> wrote:
> http://patchwork.kernel.org/patch/34385 should fix your issue (try with
> CONFIG_SLUB_DEBUG_ON still enabled and slub_debug=O on the command line).
>
> Pekka indicated he wanted this fixed in 2.6.31, so he'll probably push it
> to Linus before the 2.6.31-rc3.

Yup, if it's not too much trouble Larry, I'd appreciate if you gave it
a spin before I apply the sucker. Note to regression trackers, I don't
think this should go to -stable because it depends on other patches in
mainline and there's an obvious workaround for the problem (disable
CONFIG_SLUB_DEBUG_ON). Furthermore, it's very unlikely people will hit
this on production configurations anyway.

                        Pekka
