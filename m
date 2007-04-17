Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXDQXY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXDQXY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXDQXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:24:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbXDQXYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:24:24 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: Crispin Cowan <crispin@novell.com>
Cc: David Safford <safford@watson.ibm.com>, James Morris <jmorris@namei.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <462553A9.70504@novell.com>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
	 <1176822230.3366.65.camel@localhost.localdomain>
	 <462553A9.70504@novell.com>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 19:20:59 -0400
Message-Id: <1176852059.5946.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 16:09 -0700, Crispin Cowan wrote:
> David Safford wrote:
> > On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
> >   

<snip>

> 
> The meaning of a file is how other processes interpret it. Until then,
> /etc/resolv.conf is just a quaint bag of bits. What makes it special is
> that it is what each process gets when they open the well-known
> "/etc/resolv.conf". Which is why it is useful to guard which processes
> can read or write to /etc/resolv.conf; the name is what makes its
> content special, not the other way around.
> 

This is not correct. My private ssh keys need to be protected regardless
of the file name - it is the "bag of bits" that make it important not
the name. Similarly, you protect the integrity of the applications that
need name resolution by ensuring that the data that they read is high
integrity. You do that by controlling data not the file name used to
access the data. That is James point - a comprehensive mechanism like
SELinux allows you to comprehensively protect the integrity of data.

Karl

> Crispin
> 

