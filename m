Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYKFAWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYKFAWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYKFAWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:22:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:30926 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYKFAWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dTh/LeoP0jWbQtaf7D6+bBj1hQguTzW0mXvLVnwyRni/wiCK52gG9BHvrLp/wwnOZj
         b1cwz9vsGAD2pSsljXMjtLssXhmGBnaRiHACV46mUVofTPpu0h2uP5WJujLyUIxweDgd
         c5ifpDsm3iJ1YhmjnPjalRtmcCZRtauiBZk9w=
Message-ID: <45a44e480811051622g3b81ad71tad9ca5a341fedbcc@mail.gmail.com>
Date: Thu, 6 Nov 2008 08:22:30 +0800
From: "Jaya Kumar" <jayakumar.alsa@gmail.com>
To: "Andres Salomon" <dilinger@queued.net>
Subject: Re: [PATCH 4/4] ALSA: cs5535audio: OLPC Analog Input and MIC Bias support
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20081105173113.06e93db3@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105173113.06e93db3@ephemeral>
X-Google-Sender-Auth: 7002da491f11b5ef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 6:31 AM, Andres Salomon <dilinger@queued.net> wrote:
>
> This adds support for the special cs5535audio features that OLPC XO-1s have.
> They support switching between analog and DC recording, and the MIC requires
> toggling V_REFOUT (which this patch renames to MIC Bias) to operate.  There's
> also an EAPD tweak which is necessary for B3 and newer machines.
>
> All of this is enabled by CONFIG_OLPC (and CONFIG_SND_CS5535AUDIO, obviously).
>
> Signed-off-by: Andres Salomon <dilinger@debian.org>


Andres,

Looks okay. But can you send this patch split into 2 patches? One, the
original cs5535audio_olpc.c that I posted and your changes to it since
then. That'll make it easier for me to review.

Thanks,
jaya
