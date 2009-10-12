Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbZJLPDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbZJLPDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932466AbZJLPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:03:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbZJLPDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:03:04 -0400
Date: Mon, 12 Oct 2009 17:02:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH] USB: musb: invert arch depend string
Message-ID: <20091012150202.GB14004@elte.hu>
References: <20091012074221.GA19198@elte.hu> <1255355396-20533-1-git-send-email-vapier@gentoo.org> <20091012142849.GA1114@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012142849.GA1114@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> On Mon, Oct 12, 2009 at 09:49:56AM -0400, Mike Frysinger wrote:
> > The MUSB code relies on platform implementations that currently only
> > exists for Arm and Blackfin processors, so have the MUSB Kconfig depend
> > upon those arches.
> > 
> > This should prevent other arches from building MUSB via randconfig.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Linus, if you want to take this right now, feel free to add:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Otherwise I will queue this up to send to you in a day or so.

There's no hurry i think - neither allno nor allyes or defconfig is 
affected, it's a randconfig only bug.

	Ingo
