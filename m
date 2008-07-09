Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYGITzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYGITzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYGITzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:55:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:19741 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYGITzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lY7hmkZ3CeZY/mfb/xTQ/VbTbt2dpjp0O1h1BeTljvsnezEPLZv2hVXzSS/L5n+9Ix
         cZAHm0W6+pxOoRXlNjNu1Vc9dCNKvmB+QE7LUC1DVYptryDADx3Hy0OuRc33zW5HL1j8
         V54E2Azr8b5HQmLBknsi+1UU+IP+B599WZuyQ=
Message-ID: <1f1b08da0807091255s77033943t2b686ddb537ceaae@mail.gmail.com>
Date: Wed, 9 Jul 2008 12:55:35 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Philippe Troin" <phil@fifi.org>
Subject: Re: 2.6.25.9: system clocks works normally then speeds up 4x...
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87d4lm2792.fsf@old-tantale.fifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87d4lm2792.fsf@old-tantale.fifi.org>
X-Google-Sender-Auth: e4f4521223d82847
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 12:21 PM, Philippe Troin <phil@fifi.org> wrote:
> System info:
>
>  Dual Pentium-III
>  Tyan Tiger 133 motherboard
>  Running 2.6.25.9-40 (Fedora 8 kernel + IMQ + Layer7 patches)
>  Also tried with vanilla 2.6.25.9 - problem still shows up.
>
> Symptoms:
>
>  The system boots fine. Clock seems to run normally.
>
>  Then after a random amount of time (on the current boot, 3 days),
>  clock starts to be running 2-4x faster (on the current boot, 4x).
>
>  I have tried booting with "nohz=off highres=off" but it does not
>  help.

Could you provide the output from the following:
   sudo cat /sys/devices/system/clocksource/clocksource0/*

Did this issue occur with 2.6.24 or earlier kernels?

thanks
-john
