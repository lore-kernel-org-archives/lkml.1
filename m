Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbXFEVQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbXFEVQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765993AbXFEVQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:16:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765851AbXFEVQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:16:31 -0400
Date: Tue, 5 Jun 2007 17:16:16 -0400
From: Alan Cox <alan@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, Alan Cox <alan@redhat.com>, drepper@redhat.com,
       roland@redhat.com, arjan@infradead.org, mingo@elte.hu,
       viro@zeniv.linux.org.uk, chrisw@redhat.com, sds@tycho.nsa.gov,
       sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
Message-ID: <20070605211616.GE23291@devserv.devel.redhat.com>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> <20070603205653.GE25869@devserv.devel.redhat.com> <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil> <1181075666.3978.31.camel@localhost.localdomain> <Line.LNX.4.64.0706051658170.23379@d.namei>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706051658170.23379@d.namei>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 05:00:51PM -0400, James Morris wrote:
> This should be an unsigned long.
> 
> I wonder if the default should be for this value to be zero (i.e. preserve 
> existing behavior).  It could break binaries, albeit potentially insecure 

Agreed - DOSemu type apps and lrmi need to map at zero for vm86
