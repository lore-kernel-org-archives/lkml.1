Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZHGCfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZHGCfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbZHGCfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:35:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367AbZHGCfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:35:00 -0400
Message-ID: <4A7B92CC.2080006@suse.de>
Date: Fri, 07 Aug 2009 11:34:52 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
References: <4A79283E.7030202@kernel.org> <20090805161643.GA28436@kroah.com> <4A79B3A6.7090109@kernel.org> <20090805164919.GA27457@kroah.com> <4A79BB04.8000408@kernel.org> <20090805171547.GB10443@kroah.com> <4A7A6FAE.8020503@kernel.org> <4A7A90AB.3050407@suse.de> <20090806195848.GA29827@kroah.com>
In-Reply-To: <20090806195848.GA29827@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Greg KH wrote:
>> For now, it looks like adding the __ prefixed versions seems to be the
>> proper solution.  It's strange to provide the helper interface only
>> for full minor acquisitions anyway.  Let's do naming cleanup later.
>> How does that sound?
> 
> Well, what's the odds that I can get you to do cleanup now?  :)

I'd be happy to but whether cleaning it up would be benefitial or not
is a bit unclear.  We have 214 users of [un]register_chrdev_region()
and 118 users of [un]register_chrdev().  So, renaming the latter to,
say, create/destroy_chrdev() and make it take @baseminor and
@nr_minors should do it but I'm not quite sure whether it would worth
touching all those files.  Maybe it's better left as a mess like the
page allocation functions?

> Sure, I'll take this, only if Takashi wants the other stuff that
> depends on it.  Let me know.

Thanks.

-- 
tejun
