Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYKGKDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYKGKDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYKGKDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:03:12 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:9098 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbYKGKDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:03:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B5cYbJs9oqRIWEH8j8Oo/dIriUf2xWa+RlWXXhrn9jet639i87tC0Qm/zZB5xVIRv2
         ZZ8iPlbGpvBzKtb5NVrE4hE5CZEJ9Xlb9S1W+8LT75wgoHBcVAS9VEgzG3CkbA5BOmHM
         5lNo0KzZnyoTd2KEoWHF/Qx2iiGjd520S8Xoo=
Message-ID: <8bd0f97a0811070203w15f3a524le82f15310dab29c5@mail.gmail.com>
Date: Fri, 7 Nov 2008 05:03:10 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] ALSA: have snd_BUG_ON() always refer to arguments
Cc: alsa-devel@alsa-project.org, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5hr65nq2p5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226023521-10037-1-git-send-email-vapier@gentoo.org>
	 <s5hk5bgqa61.wl%tiwai@suse.de>
	 <8bd0f97a0811062329l26f8338ahbb62bab9e8284c36@mail.gmail.com>
	 <s5hbpwsq92z.wl%tiwai@suse.de>
	 <8bd0f97a0811062357y52ff0107yee74c0a2ff010019@mail.gmail.com>
	 <s5h7i7gq7xz.wl%tiwai@suse.de>
	 <8bd0f97a0811070005r6a9fb1e1s9fd88bd264ef8ae2@mail.gmail.com>
	 <s5h4p2kq71k.wl%tiwai@suse.de>
	 <8bd0f97a0811070130w540f8110l978c8910fad924e0@mail.gmail.com>
	 <s5hr65nq2p5.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 04:56, Takashi Iwai wrote:
> At Fri, 7 Nov 2008 04:30:43 -0500, Mike Frysinger wrote:
>> we arent talking about assert() here nor are we talking about assert()
>> behavior, but i would say it was a poor decision.  the fact that it's
>> called snd_BUG_ON() instead of snd_WARN_ON() is also a bit broken imo.
>>  BUG() kills the kernel while WARN() complains, and snd_BUG_ON() is
>> clearly in the latter category.
>
> Right, that's a bit confusing.  It came because we had already
> snd_BUG() macro.  I took snd_BUG_ON() from the analogy of snd_BUG().
>
>> that said, you could just define snd_BUG_ON() in terms of WARN_ON()
>> all the time:
>
> Hm, this looks a good alternative, too.
> Though, this was already fixed on my git tree in another way...

np.  if it's fixed now, i'm happy.  maybe keep in mind my suggestion
if someone else complains about the current code not working for them
:).

thanks for your help.
-mike
