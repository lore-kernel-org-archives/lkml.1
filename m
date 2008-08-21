Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYHUITR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYHUITR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYHUITD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:19:03 -0400
Received: from eisentraut.org ([85.214.91.16]:60502 "EHLO gattler.pezone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYHUITB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:19:01 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 04:19:00 EDT
From: Peter Eisentraut <peter_e@gmx.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11381] New: default shmmax
Date: Thu, 21 Aug 2008 11:19:14 +0300
User-Agent: KMail/1.9.9
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Pierre Peiffer <peifferp@gmail.com>, containers@lists.osdl.org
References: <bug-11381-10286@http.bugzilla.kernel.org/> <20080820120043.e6e7e436.akpm@linux-foundation.org>
In-Reply-To: <20080820120043.e6e7e436.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808211119.15788.peter_e@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> It would be useful to get distro input on this.  Do they override the
> kernel default at boot time?  If so, what do they do?

Debian and Ubuntu have a sysctl.conf that is processed at boot time, but it 
does not contain anything related to shm* by default.

Suse has a sysctl.conf, but it is not processed at boot by default.  You have 
to activate a special boot service in the runlevel system to make it actually 
run at boot.  (Try explaining that to a PostgreSQL user.)  There is nothing 
related to shm* in the default configuration.
