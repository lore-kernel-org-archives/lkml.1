Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbZDAVtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbZDAVtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbZDAVtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:49:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51979 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZDAVtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:49:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Date: Wed, 1 Apr 2009 23:49:09 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904012329.21362.rjw@sisk.pl> <20090401213756.GU18394@sequoia.sous-sol.org>
In-Reply-To: <20090401213756.GU18394@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904012349.10919.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009, Chris Wright wrote:
> * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > This may be caused by the recent PM changes.  Can you please test if commit
> > 8efb8c76fcdccf5050c0ea059dac392789baaff2 is fine?
> 
> I just tested on my t400, it's not[1].  See same symptoms as Arkadiusz.
> Seems as if it responds to initial apci event, I see some disk activity,
> then nothing (as if it tried to wakeup, then went back to sleep).
> 
> [1] 15f7176eb1cccec0a332541285ee752b935c1c85 bad
>     fae3e7fba4c664b3a15f2cf15ac439e8d754afc2 good(ish) (display stays blank)

Hmm, can you also test commit 0a0c5168df270a50e3518e4f12bddb31f8f5f38f, please?

Rafael
