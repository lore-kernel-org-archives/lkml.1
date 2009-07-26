Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZGZWiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZGZWiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 18:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZGZWiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 18:38:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbZGZWiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 18:38:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH v2 -tip][RFC] serial8250: update to dev_pm_ops
Date: Mon, 27 Jul 2009 00:38:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Erik Ekman <erik@kryo.se>,
       Alan Cox <alan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <20090701083737.41f28c7d.erik@kryo.se> <200907262145.46363.rjw@sisk.pl> <200907262252.41429.elendil@planet.nl>
In-Reply-To: <200907262252.41429.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907270038.26549.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Frans Pop wrote:
> On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> > In fact, I wouldn't advise anyone to do these conversions mechanically.
> 
> With hindsight I'd say you are correct.
> 
> In that case would it maybe have been better to have a build time warning 
> about the need to convert drivers rather than a run time one? Run time 
> warnings have a much higher annoyance factor and will thus "invite" more 
> people into having a shot at getting rid of them.
> 
> But I guess partly it's also just the nature of this change: it looks 
> trivial due to the corresponding terms.

Well, in fact the patch that added the warning wasn't mine. :-)

Anyway, the purpose was to get the attention of the people who maintain
those drivers mostly, AFAICS.

Best,
Rafael
