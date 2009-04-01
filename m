Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbZDAVCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbZDAVCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761545AbZDAVB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:01:59 -0400
Received: from sous-sol.org ([216.99.217.87]:56105 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761215AbZDAVB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:01:57 -0400
Date: Wed, 1 Apr 2009 14:00:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090401210054.GS18394@sequoia.sous-sol.org>
References: <200904011155.20751.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904011155.20751.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> and this as bad commit:
> 
> 7f7ace0cda64c99599c23785f8979a072e118058 is first bad commit

Does it make any difference if you roll fwd a couple commits to:

802bf931f2688ad125b73db597ce63cc842fb27a

That fixes a possible problem with the cpumask change and interrupt
migration.

And to be clear, one commit earlier works?

fae3e7fba4c664b3a15f2cf15ac439e8d754afc2

thanks,
-chris
