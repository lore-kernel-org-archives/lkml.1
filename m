Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0BMWy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:54:57 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:55169 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab0BMWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rec24yzlPCSWpdvBoRt6E4/b0QPYCfRJAeeLE5X2bbabuG0tE/DXWPYHLI8zzkaMg1
         1pocG9Sbbz1WnMoAH4YQPijKk8iGcfkdbXwheGMRXdaSrLk5xpxx6QoWCySP7DIcYpje
         ITj+1FxQuc5lImPNSjoA8Te+KsQuFaNRwpXSw=
Message-ID: <4B772DB8.7060105@arm.com>
Date: Sat, 13 Feb 2010 22:54:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 05/10] ARM: ftrace: add ENDPROC annotations
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-6-git-send-email-rabin@rab.in>
In-Reply-To: <1266090518-31120-6-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rabin Vincent wrote:
> When building as Thumb-2, the ".type foo, %function" annotation in
> ENDPROC seems to be required in order for the assembly routines to be
> recognized as Thumb-2 code.  If the ENDPROC annotations are not present,
> calls to these routines are generated as BLX instead of BL.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin
