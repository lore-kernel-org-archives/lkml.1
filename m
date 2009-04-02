Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbZDBVAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbZDBVAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761741AbZDBVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:00:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844AbZDBVAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:00:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Date: Thu, 2 Apr 2009 23:00:00 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904020023.58363.rjw@sisk.pl> <20090401230637.GW18394@sequoia.sous-sol.org>
In-Reply-To: <20090401230637.GW18394@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022300.01707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Chris Wright wrote:
> * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > Sorry for the misunderstanding, I thought the breakage might be introduced
> > between 15f7176eb1cccec0a332541285ee752b935c1c85 and
> > 0a0c5168df270a50e3518e4f12bddb31f8f5f38f, so I thought it would be a good
> > idea to verify if 0a0c5168df270a50e3518e4f12bddb31f8f5f38f fails too.
> 
> Ah, sure.  It fails too (both test_suspend=mem and regular suspend/resume).

Having looked at the commit the Arek's bisect turned up I don't think it's
likely to have caused this problem to appear.

It seems that the regression had been introduced before the PM and PCI updates
went it, so I bet it's one of the x86 changes.  Ingo, are there any commits
obviously worth testing?

Rafael
