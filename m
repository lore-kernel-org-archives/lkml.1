Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0CLBIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:08:22 -0500
Received: from mail-px0-f198.google.com ([209.85.216.198]:36749 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0CLBIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=sGub5h4iBjwKAlu5ULSjueedEsiXIKMuExkFAEgPjUKzfQ6RV5Odtjx6MMzRFOvbFf
         65h3mEis7SHxXTH+LrKBZKpk/Zyha+FJuiF/r0fgvmXxn9/pe7agfctSqu0bzXIw0Ig6
         L5MQJCTqY1jnKAaQgXo9uklU384TPGRZFPDQo=
MIME-Version: 1.0
In-Reply-To: <1268355632-32348-1-git-send-email-lrodriguez@atheros.com>
References: <1268355632-32348-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 11 Mar 2010 17:07:59 -0800
X-Google-Sender-Auth: 4eeb3cc8a5f608e3
Message-ID: <43e72e891003111707v71af9eb9r2da0328f6a877886@mail.gmail.com>
Subject: Re: [FYI] cfg80211: HT40 fix for APs with odd country IEs for 
	2.6.33.y
To: linux-wireless@vger.kernel.org, stable@kernel.org
Cc: linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 5:00 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Just a heads up to distribution maintainers, 2.6.33 has an
> issue with disabling HT40 channels if you connect to an AP
> that has an odd country IE. Specifically if your AP sends
> out country IEs as follows:
>
> [1-1]
> [2-2]
> [3-3]
> [4-4]
> [5-5]
> [6-6]
> [7-7]
> [8-8]
> [9-9]
> [10-10]
> [11-11]
>
> instead of like this:
>
> [1-11]
>
> Then HT40 gets disabled. This issue was fixed on 2.6.34 and the fixes
> were not propagated to 2.6.33.y as they are not "critical" fixes
> per se, but if you do value this as "important" you may want to
> fetch them and apply them to your 2.6.33.y kernel tree.
>
> I've backported them and stashed them here:
>
> http://kernel.org/pub/linux/kernel/people/mcgrof/patches/cfg80211/2010-03/reg-fixes-33/01-ht40-odd-country-ie/

If no one has complaints I'm going to cherry pick this seires and the
suspend/resume fixes on compat-wireless-2.6.33.y releases.

  Luis
