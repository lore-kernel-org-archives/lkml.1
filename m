Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZCOHOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZCOHOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 03:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZCOHNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 03:13:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZCOHNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 03:13:50 -0400
Date: Sun, 15 Mar 2009 08:13:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LMML <linux-media@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [build failure] Re: [GIT PATCHES for 2.6.29-rc8] V4L/DVB fixes
Message-ID: <20090315071322.GA5337@elte.hu>
References: <20090313134333.563c0565@pedra.chehab.org> <20090315071106.GA4979@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315071106.GA4979@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, latest upstream (2.6.29-rc8) fails to build with the 
> attached config:
> 
>   MODPOST 531 modules
> ERROR: "dibusb_dib3000mc_frontend_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!
> ERROR: "dibusb_dib3000mc_tuner_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!
> ERROR: "dibusb_dib3000mc_frontend_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-a800.ko] undefined!
> ERROR: "dibusb_dib3000mc_tuner_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-a800.ko] undefined!

Note, the tree i tried is post-rc8: v2.6.29-rc8-90-g326d851.

It already includes the latest V4L/DVB fixes.

	Ingo
