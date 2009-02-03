Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZBCTaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZBCTaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZBCTam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:30:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56440 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZBCTam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:30:42 -0500
Date: Tue, 3 Feb 2009 20:30:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Greg KH <gregkh@suse.de>, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>, Luca Olivetti <luca@ventoso.org>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
Message-ID: <20090203193029.GA13726@elte.hu>
References: <20090203172836.GA6964@elte.hu> <1233685361.5903.131.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233685361.5903.131.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@fifo99.com> wrote:

> On Tue, 2009-02-03 at 18:28 +0100, Ingo Molnar wrote:
> > FYI, -tip qa keeps triggering this bootup crash occasionally, ever since 
> > June 2008 when a DVB merge brought in this new driver:
> 
> It looks like it could be a config problem.. The crash happens around 
> these two symbol "af9005_rc_keys", and "af9005_rc_keys_size" , and they 
> are both defined inside af9005-remote.c different from where the init 
> functions is lcoated .. af9005-remote.c needs a special config 
> CONFIG_DVB_USB_AF9005_REMOTE to get compiled which you have disabled..

ok - but it shouldnt crash, obviously.

	Ingo
