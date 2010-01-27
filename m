Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831Ab0A0Lu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0A0Lu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553Ab0A0Lu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:50:28 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:50582 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0A0LuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZL3b+nQN/mImZ2RRoNaOwSqasiR3o09h5pTueBmOkbWKH9gkdO99GgWetMBzxcs7Ni
         P2PWZNYxGMBYOETW8/iBBHcfTQcuz2DbAKFbgDVPNsXAUCngNaHiUg28n8WdbiZ+RRzT
         tAHasfdniOveOp4zILUaPLAi860J5BhwBDQCc=
MIME-Version: 1.0
In-Reply-To: <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk>
References: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain>
	 <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk>
Date: Wed, 27 Jan 2010 20:50:24 +0900
X-Google-Sender-Auth: 8d6707c8ad25284b
Message-ID: <2f11576a1001270350v4d6c7ed5qe1a1bac41b233456@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roman Jarosz <kedgedev@gmail.com>, A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 Chris Wilson <chris@chris-wilson.co.uk>:
> Having missed the ENOMEM return via i915_gem_fault(), there are probably
> other paths that I also missed. By not enabling NORETRY by default these
> paths can run the shrinker and take memory from the system (but not from
> our own inactive lists because our shrinker can not run whilst we hold
> the struct mutex) and this may allow the system to survive a little longer
> whilst our drivers consume all available memory.
>
> References:
>  OOM killer unexpectedly called with kernel 2.6.32
>  http://bugzilla.kernel.org/show_bug.cgi?id=14933
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Eric Anholt <eric@anholt.net>
> Cc: stable@kernel.org

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
