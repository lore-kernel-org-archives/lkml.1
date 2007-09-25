Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbXIYIvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbXIYIvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXIYIvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:51:13 -0400
Received: from ozlabs.org ([203.10.76.45]:48901 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXIYIvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:51:12 -0400
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F8C8AA.3030803@gmail.com>
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>
	 <1190677332.27805.229.camel@localhost.localdomain>
	 <46F86727.4050004@gmail.com>
	 <1190686320.27805.258.camel@localhost.localdomain>
	 <46F874DB.5070205@gmail.com>
	 <1190690493.27805.263.camel@localhost.localdomain>
	 <46F8822D.2010003@gmail.com>
	 <1190695118.27805.307.camel@localhost.localdomain>
	 <46F8C5ED.6060101@gmail.com>  <46F8C8AA.3030803@gmail.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 18:50:49 +1000
Message-Id: <1190710249.27805.326.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 17:36 +0900, Tejun Heo wrote:
> Hmmm.... There doesn't seem to any reason why the blocking should be
> after calling ->exit().  And, yeah, it would be more useful and
> intuitive if blocking happens before ->exit().  What do you think?

*That* I have no problem with.

I was going to say "just grab a reference to every module" except if a
new module is loaded you don't know about it.

If you move your blocking, it seems fine.

Thanks!
Rusty.

