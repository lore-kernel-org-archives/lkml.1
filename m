Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0CIXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:01:48 -0500
Received: from ppp173-197.broadband.gorge.net ([209.216.173.197]:48968 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755740Ab0CIXBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:01:42 -0500
Date: Tue, 9 Mar 2010 22:49:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100309224941.79511705@lxorguk.ukuu.org.uk>
In-Reply-To: <m1fx4apgch.fsf@fess.ebiederm.org>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
	<20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	<20100308190857.400bde09@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
	<m1fx4apgch.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> time.  If pathnames were not fundamentally important we could apply
> a patch like the one below and allow unprivileged users to unshare
> the mount namespace and mount filesystems wherever.  There is nothing
> fundamental about those operations that require root privileges except
> that you are manipulating the pathnames of objects.

And in a purely SELinux enviromnment your patch would work out because
you could use labels to control this stuff.
 

> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -

It does raise the question about whether you can do it if you had a
namespace property of "ignore suidness". I'm not sure thats enough
however.
