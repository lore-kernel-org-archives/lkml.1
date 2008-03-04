Return-Path: <linux-kernel-owner+w=401wt.eu-S1764566AbYCDRVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764566AbYCDRVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763384AbYCDRV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:21:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764133AbYCDRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:21:26 -0500
Date: Tue, 4 Mar 2008 09:21:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Casey Schaufler <casey@schaufler-ca.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
 loaded
In-Reply-To: <20080304131055.GA25577@ubuntu>
Message-ID: <alpine.LFD.1.00.0803040920080.12253@woody.linux-foundation.org>
References: <20080304131055.GA25577@ubuntu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Mar 2008, Ahmed S. Darwish wrote:
> 
> Smackfs initialization without an enabled Smack leads to
> an early Oops that renders the system unusable.

I really think this is bogus. Global enables like this are just wrong, and 
a sign that something else bad is going on.

What is the oops? Why does it happen?

		Linus
