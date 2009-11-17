Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZKQBBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZKQBBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZKQBBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:01:24 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:63685 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZKQBBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:01:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Olc7f1E36jv7xBRXgY6egNf7Pm1CRXJSTl3VcRdRZ0BXB1vVkyFk9LhGDmWlCSPqJE
         6rAWdVGU7o7qEUTFloLab3+dkDB39XCCxDA3WRizjlQ4/ktf3a6wlirkIGvnnbw9RcNp
         oXzZljMmaQdlsxC+YwLUpn7UQ5IR/ORQRKCps=
MIME-Version: 1.0
In-Reply-To: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 16 Nov 2009 17:01:09 -0800
Message-ID: <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
To: Michael Renzmann <mrenzmann@madwifi-project.org>
Cc: madwifi-devel@lists.sourceforge.net, madwifi-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 15, 2009 at 2:52 AM, Michael Renzmann
<mrenzmann@madwifi-project.org> wrote:
> Hi all.
>
> As you might have noticed, there currently is a discussion [1] going on
> about the future directions of the MadWifi project, including a decision
> how to deal with MadWifi driver. It turns out that there are pretty
> contrary positions in this regard: some would like to see MadWifi being
> dumped completely as soon as possible, others would prefer to continue
> development and even implement new features.
>
> What do others think? It appears to me that we know too little about what
> MadWifi is actually used for today and why. Thus I'd like to start a quick
> survey.
>
> It would be great if you could answer some or - ideally - all of the
> following questions:
>
>  1. What are you using MadWifi for?
>
>  2. Did you already evaluate ath5k/ath9k? If no, why not?
>
>  3. In case you evaluated ath5k/ath9k but did not yet switch: what is the
> reason for your decision, and what is required before you could switch?
>
> Any input is highly welcome, thanks in advance for your time.
>
> Bye, Mike
>
> [1] http://thread.gmane.org/gmane.linux.drivers.madwifi.project/165
>

Everyone on kernels >= 2.6.25 would have tried ath5k, granted with
probably a horrible experience as it was still early development.

Everyone on >= 2.6.27 would have tried ath9k.

So some sort of survey on this on madwifi-devel is not fair or just to
ath5k/ath9k as the only thing it would bring out is those romantics
still reading madwifi-devel due to some sort of attachment to it. I'm
not saying those attachments are bad I'm just saying MadWifi is long
dead to many and those still reading to madwifi lists are obviously
still trying to use it for one reason or another.

Madwifi's future as a Linux driver does not depend on what users wish
would happen on a legacy driver due to romantic experiences with it
with extensive features and its history. From a development
perspective the future of any Linux driver is just to go upstream. Its
very simple. Any company developing a driver out-of-tree is just not
doing Linux driver development the right way.

Linux distributions won't go around carrying legacy drivers unless
they serve a purpose and what you'll see is Linux distributions prefer
upstream drivers for an obvious reason -- its where Linux drivers
should go.

If a few developers still exist who are committed to helping maintain
madwifi until ath5k gets feature-parred the easiest solution now
(since the HAL is open) is to just throw it into staging and hopefully
that'll attract more developers to help keep it up to date with actual
current kernels. No -- you won't get 2.4 kernel support though -- if
you're on 2.4 you should just upgrade. But really best thing as a user
or motivated developer is to just annotate a missing feature and add
it upstream through mac80211/cfg80211 as ath5k really should be in a
decent condition by current kernel standards and Madwifi as a codebase
can probably just remain in maintenance mode outside of the kernel.

Anything else is just wasting time and electrons.

  Luis
