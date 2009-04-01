Return-Path: <linux-kernel-owner+w=401wt.eu-S934627AbZDAVjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934627AbZDAVjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZDAVjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:39:15 -0400
Received: from sous-sol.org ([216.99.217.87]:56758 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756024AbZDAVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:39:12 -0400
Date: Wed, 1 Apr 2009 14:37:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090401213756.GU18394@sequoia.sous-sol.org>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904012329.21362.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012329.21362.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This may be caused by the recent PM changes.  Can you please test if commit
> 8efb8c76fcdccf5050c0ea059dac392789baaff2 is fine?

I just tested on my t400, it's not[1].  See same symptoms as Arkadiusz.
Seems as if it responds to initial apci event, I see some disk activity,
then nothing (as if it tried to wakeup, then went back to sleep).

[1] 15f7176eb1cccec0a332541285ee752b935c1c85 bad
    fae3e7fba4c664b3a15f2cf15ac439e8d754afc2 good(ish) (display stays blank)
