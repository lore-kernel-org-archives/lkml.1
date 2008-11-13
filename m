Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYKMLlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYKMLlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYKMLll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:41:41 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42107 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYKMLll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:41:41 -0500
Date: Thu, 13 Nov 2008 12:40:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mathieu Chouquet-Stringer <mchouque@free.fr>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081113114001.GC26778@kernel.dk>
References: <20081109195033.GA1335@mobydick> <20081112184236.GR26778@kernel.dk> <200811122237.03882.rjw@sisk.pl> <200811121357.02233.jbarnes@virtuousgeek.org> <20081113073341.GV26778@kernel.dk> <20081113084144.GX26778@kernel.dk> <491C0C31.1090003@upcomillas.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491C0C31.1090003@upcomillas.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13 2008, Romano Giannetti wrote:
> 
> Jens Axboe wrote:
> >On Thu, Nov 13 2008, Jens Axboe wrote:
> >>On Wed, Nov 12 2008, Jesse Barnes wrote:
> 
> >>Yep, it's intel graphics, sorry I should have mentioned that!
> >>
> >>>Jens, does suspend/resume work if you just do it from the console
> >>>(echo mem > /sys/power/state) with i915 loaded?
> >>Let me try that right away.
> >
> >Seems to work fine from the console, even with i915 loaded and X on the
> >login screen on a different vt.
> >
> 
> Isn't a VC switch used on suspend/resume? If yes, this could be an
> incarnation of http://bugzilla.kernel.org/show_bug.cgi?id=11947

Nope, no vc switch in my setup. This is on ubuntu, when I ran opensuse
on this machine it did do vc switches by default. The vc switch can help
work around mode setting restore problems, but it seems the intel
graphics doesn't need it.

-- 
Jens Axboe

