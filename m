Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXCWU70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXCWU70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934321AbXCWU70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:59:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbXCWU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:59:25 -0400
Message-ID: <46043F96.8030800@zytor.com>
Date: Fri, 23 Mar 2007 13:59:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Andrew Morton <akpm@linux-foundation.org>, "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl: vfs_cache_divisor
References: <20061214223718.GA3816@elf.ucw.cz> <20061216094421.416a271e.randy.dunlap@oracle.com> <20061216095702.3e6f1d1f.akpm@osdl.org> <458434B0.4090506@oracle.com> <1166297434.26330.34.camel@localhost.localdomain> <20061219063413.GI24090@1wt.eu> <1166511171.26330.120.camel@localhost.localdomain> <20070106103331.48150aed.randy.dunlap@oracle.com> <459FF60D.7080901@zytor.com> <1168112266.2821.2.camel@entropy> <20070106121301.d07de0c9.akpm@osdl.org> <45A0041F.4060903@zytor.com> <20070319122740.286f602e.randy.dunlap@oracle.com> <20070319133613.9f4881db.akpm@linux-foundation.org> <45FEF5BC.90809@oracle.com> <45FF6189.9080508@zytor.com> <20070321160132.983812ac.randy.dunlap@oracle.com> <20070321161140.457a3cd7.akpm@linux-foundation.org> <CDF579E6-342C-4B99-916A-3CE118ABD02F@mac.com> <46043A66.7030102@oracle.com>
In-Reply-To: <46043A66.7030102@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> Hi,
> That makes a lot of sense to me.  It gives us finer-grained control
> without having to support fixed-point data.
> 
> I've been working on the fixed-point data patch, but I'm going to give
> this method some time also, to see how it looks in code (instead of just
> thinking about it).
> 

Well, to be specific, it actually is the same thing with different 
syntax (38.55 or 3855/100).

	-hpa
