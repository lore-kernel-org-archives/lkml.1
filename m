Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYJQUmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYJQUmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYJQUlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:41:52 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:14557 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYJQUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WSjlgjyZRyJV0DFKaZAX23w7M2EvJ3H1yCj4JLUUyLFw3xqOKvxAIIIeDQOiByKIrw
         wDtPNcNLQMu+r7ylw7FgKRPOnVux6UvZSm3a7rrJHgPPDroO7dAswQG4m2CuM9mF/0Iq
         WMbRqT4qbiiJc5/rVUKiI+DQwjcr8Ote2LXSk=
Message-ID: <69e28c910810171341g4adee0e9t6f551119f076813e@mail.gmail.com>
Date: Fri, 17 Oct 2008 22:41:49 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Dan Williams" <dcbw@redhat.com>,
       "Tim Gardner" <tim.gardner@canonical.com>
In-Reply-To: <43e72e890810131723k227ff97bya17aee0d9a5da2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014010202.71d13eaf@werewolf.home>
	 <20081013232432.GB32550@tuxdriver.com>
	 <43e72e890810131723k227ff97bya17aee0d9a5da2b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 2:23 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> cfg80211: Unknown parameter `ieee80211_regdom'
>
> Ahh this one.. this is the 2 character module parameter you can pass
> to cfg80211 upon load and this is available only when
> CONFIG_WIRELESS_OLD_REGULATORY is enabled.
>
> I still don't see why you are seeing this, as your modprobe command
> did not pass any module parameter options.. do you have some options
> for cfg8021 in your distribution place for them on /etc/ somewhere?
>
> <snip>
>
>  Luis
>

Let me have a guess: /etc/modprobe.d/options:
options cfg80211 ieee80211_regdom="EU"

I also have this in my modprobe options file to avoid having to unload
all wireless drivers and stack modules, then reload manually. Possibly
some distros auto-set this based on the country selection. Though I
agree that CRDA is way neater.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
