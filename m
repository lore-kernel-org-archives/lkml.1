Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZIROTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZIROTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZIROTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:19:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZIROTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:19:33 -0400
Date: Fri, 18 Sep 2009 07:18:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was:
 Re: [PATCH] Remove broken by design and by implementation devtmpfs maintenance
 disaster)
In-Reply-To: <20090918060210.GC7104@kroah.com>
Message-ID: <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
 <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> <1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Sep 2009, Greg KH wrote:
> 
> I think the udev version in older Fedora releases can't handle this
> kernel option, which is fine, just don't enable it.  Newer versions can
> handle it, right?

.. conversely, if you can't be bothered to set up /dev/null and /dev/zero 
correctly, I would suggest that you not set them up AT ALL in devtmpfs.

The thing is, 0600 for those nodes is just _wrong_. Don't do it.

			Linus
