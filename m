Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZKKUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZKKUnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbZKKUnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:43:20 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:58526 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbZKKUnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qjcBohuVHMwdF4DjP/0KmCfkFg4Au9nXK0sHzGvzhU1Bvf+XjYKptLPHB2BwcZAE4J
         fCFfKnu1ryBDEJ06iTtUh4YhZVKcZXQ3hhobC4Anf+s5usLRuW/70S8GFl6wcA5RV/2p
         r8D3bvIhUIF0y89/TblHE5Fr5oFtudYZTmkig=
MIME-Version: 1.0
In-Reply-To: <1250617512-23567-1-git-send-email-jon-hunter@ti.com>
References: <1250617512-23567-1-git-send-email-jon-hunter@ti.com>
Date: Wed, 11 Nov 2009 12:43:23 -0800
X-Google-Sender-Auth: 905a819beffbeebf
Message-ID: <1f1b08da0911111243s2615c22ake73a3242becb7b70@mail.gmail.com>
Subject: Re: [PATCH 0/2] Dynamic Tick: Enabling longer sleep times on 32-bit 
	machines
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 9:45 AM, Jon Hunter <jon-hunter@ti.com> wrote:
> From: Jon Hunter <jon-hunter@ti.com>
>
> This is a resend of the patch series shown here:
> http://www.spinics.net/lists/kernel/msg891029.html
>
> This patch series has been rebase on the linux-2.6-tip timers/core branch per
> request from Thomas Gleixner.
>
> This patch series ensures that the wrapping of the clocksource will not be
> missed if the kernel sleeps for longer periods and allows 32-bit machines to
> sleep for longer than 2.15 seconds.
>
> Jon Hunter (2):
>  Dynamic Tick: Prevent clocksource wrapping during idle
>  Dynamic Tick: Allow 32-bit machines to sleep for more than 2.15
>    seconds

I could have sworn this was in mainline by now, but I recently was
looking for the code and can't find it there or in -tip either.

Thomas, are they just hiding somewhere I can't find?

Jon, you've been terribly patient and great about resubmitting these
patches over and over. If I'm not just being crazy and missing these
patches in front of my nose, are you still willing to submit them
again? I think they'll be quite useful as folks start pushing the NOHZ
idle times out.

thanks
-john
