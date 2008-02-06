Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbYBFVLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbYBFVLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYBFVL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:11:26 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53128 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbYBFVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:11:25 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080206202110.GA20528@sergelap.ibm.com> (serue@us.ibm.com)
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
References: <20080205213616.343721693@szeredi.hu> <20080205213705.120219893@szeredi.hu> <20080206202110.GA20528@sergelap.ibm.com>
Message-Id: <E1JMrXw-0000qq-O9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 06 Feb 2008 22:11:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	t->table[0].mode = 0644;
> 
> Yikes, this could be a problem for containers, as it's simply tied to
> uid 0, whereas tying it to a capability would let us solve it with
> capability bounds.
> 
> This might mean more urgency to get user namespaces working at least
> with sysfs, else this is a quick way around having CAP_SYS_ADMIN taken
> out of a container's capability bounding set.

I think I understand the problem, but not the solution.  How do user
namespaces going to help?

Maybe sysctls just need to check capabilities, instead of uids.  I
think that would make a lot of sense anyway.

Thanks,
Miklos
