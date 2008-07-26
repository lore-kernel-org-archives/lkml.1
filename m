Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYGZPUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYGZPUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYGZPUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:20:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40818 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbYGZPUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:20:07 -0400
Date: Sat, 26 Jul 2008 17:19:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption.
	prev->next should be next (ffff88003b8f82f8)
Message-ID: <20080726151921.GB30280@elte.hu>
References: <Pine.LNX.4.44L0.0807240931220.3494-100000@netrider.rowland.org> <200807260806.24859.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807260806.24859.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> On Thursday 24 July 2008, Alan Stern wrote:
> > Can you make the necessary change and try it out?
> 
> This resolves the problem for me ... and, I'd expect, for Ingo.

yeah. Please assume:

  Tested-by: Ingo Molnar <mingo@elte.hu>

and dont wait for me testing it thoroughly - i'll notify you if the 
problem comes back.

	Ingo
