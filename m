Return-Path: <linux-kernel-owner+w=401wt.eu-S935944AbZDAX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935944AbZDAX2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934582AbZDAXIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:08:04 -0400
Received: from sous-sol.org ([216.99.217.87]:52858 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934487AbZDAXID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:08:03 -0400
Date: Wed, 1 Apr 2009 16:06:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090401230637.GW18394@sequoia.sous-sol.org>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904012349.10919.rjw@sisk.pl> <20090401221433.GV18394@sequoia.sous-sol.org> <200904020023.58363.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904020023.58363.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> Sorry for the misunderstanding, I thought the breakage might be introduced
> between 15f7176eb1cccec0a332541285ee752b935c1c85 and
> 0a0c5168df270a50e3518e4f12bddb31f8f5f38f, so I thought it would be a good
> idea to verify if 0a0c5168df270a50e3518e4f12bddb31f8f5f38f fails too.

Ah, sure.  It fails too (both test_suspend=mem and regular suspend/resume).
