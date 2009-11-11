Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZKKWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZKKWhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbZKKWhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:37:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44684 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461AbZKKWhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:37:39 -0500
Subject: Re: [PATCH 0/2] Dynamic Tick: Enabling longer sleep times on
 32-bit machines
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4AFB2547.7080008@ti.com>
References: <1250617512-23567-1-git-send-email-jon-hunter@ti.com>
	 <1f1b08da0911111243s2615c22ake73a3242becb7b70@mail.gmail.com>
	 <4AFB2547.7080008@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 14:37:21 -0800
Message-ID: <1257979042.3100.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 14:57 -0600, Jon Hunter wrote:
> john stultz wrote:
> > I could have sworn this was in mainline by now, but I recently was
> > looking for the code and can't find it there or in -tip either.
> > 
> > Thomas, are they just hiding somewhere I can't find?
> > 
> > Jon, you've been terribly patient and great about resubmitting these
> > patches over and over. If I'm not just being crazy and missing these
> > patches in front of my nose, are you still willing to submit them
> > again? I think they'll be quite useful as folks start pushing the NOHZ
> > idle times out.
> 
> Absolutely! It is still on my to-do list, but unfortunately, I got busy 
> with a couple other things.
> 
> With regard to the last patch set I submitted for this, Thomas had an 
> issue with one of the patches. I understand the concern, but I am not 
> sure  which would be the preferred way to handle this. See the below thread:
> 
> http://marc.info/?l=linux-kernel&m=125062817124381&w=2
> 
> If you or Thomas have any feedback on this, I could re-work the patch 
> against the latest kernel tree.

Ok. I think Thomas is right there, setting the expiration to
max_time_delta makes the most sense. Honestly I suspect we don't ever
hit that case in the current code (no timers for 12 days), so its
probably an untested code path as it stands.

thanks
-john

