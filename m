Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYIDPk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYIDPk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYIDPkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:40:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60830 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYIDPks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:40:48 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Thu, 04 Sep 2008 16:06:51 +0200)
Subject: Re: unprivileged mounts git tree
References: <20080808002537.GA5364@us.ibm.com> <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu> <20080827153628.GA11242@us.ibm.com> <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
Message-Id: <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Sep 2008 17:40:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008, Miklos Szeredi wrote:
> On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> > Are you going to revert the change forcing CL_SLAVE for
> > !capable(CAP_SYS_ADMIN)?  I don't think we want that - I think that
> > *within* a set of user mounts, propagation should be safe, right?
> > 
> > Will you be able to do this soon?  If not, should we just do the part
> > returning -EPERM when turning a shared mount into a user mount? 
> 
> OK, let's do that first and the tricky part (propagation vs. user
> mounts) later.  Will push after I've tested it.

Here it is:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git unprivileged-mounts

I don't know what's next, this patchset has been in and out of -mm for
as long as I can remember, but it hasn't generated much interest
outside the two of us :)

I do think this is an important feature though, even if not as sexy as
some other things.

Al?  Is there any chance of this making it to 2.6.28?

Thanks,
Miklos
