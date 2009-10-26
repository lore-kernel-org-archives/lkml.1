Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZJZT2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZJZT2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZJZT2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:28:36 -0400
Received: from foo.birdnet.se ([213.88.146.6]:60466 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755563AbZJZT2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:28:35 -0400
Message-ID: <20091026192839.22901.qmail@stuge.se>
Date: Mon, 26 Oct 2009 20:28:39 +0100
From: Peter Stuge <peter@stuge.se>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
       linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
	at lid open time"
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
	linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
References: <4AE4BBBC.2070809@gmail.com> <20091026015230.6438.qmail@stuge.se> <20091026090234.32ae7656@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026090234.32ae7656@jbarnes-g45>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> > Can I help solve this somehow?
> 
> I posted a patch that fixed an X40 I was testing:
> drm/i915: save/restore BLC histogram control reg across suspend/resume
> 
> can you give it a try and see if it works for you?

It works beautifully. Fantastic. Thank you very much! It was marked
Accepted in patchwork but if you need one then here's a:

Tested-by: Peter Stuge <peter@stuge.se>


> It may not be related to Riccardo's report, since the above patch
> isn't really related to the lid switch problem.

Agree, I reacted to his message because he saw a similar symptom and
I was just on my way to write a message about it anyway.


//Peter
