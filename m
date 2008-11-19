Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYKSR7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYKSR7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYKSR7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:59:41 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55653 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYKSR7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:59:41 -0500
To: tj@kernel.org
CC: bharrosh@panasas.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <4922E622.50401@kernel.org> (message from Tejun Heo on Wed, 19
	Nov 2008 00:58:26 +0900)
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com> <48B6E417.5030605@kernel.org> <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org> <20080828181720.GB23898@kroah.com> <491BEC4E.9030505@kernel.org> <492136F5.8010903@kernel.org> <20081117171717.GB31306@kroah.com> <49221CE8.1050402@kernel.org> <49221D23.8040904@kernel.org> <4922C6BB.5020203@panasas.com> <4922E622.50401@kernel.org>
Message-Id: <E1L2rKn-0003Un-AO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Nov 2008 18:59:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Tejun Heo wrote:
> Hmmm... if you can use this change, I think you can push it through
> whatever tree you push patches through, things can be taken care of when
> merging or we can put it in Greg's tree and ask Miklos to pull from the
> tree first but Greg doesn't keep a stable tree.  Hmm... if your patches
> are gonna go through some public tree, I think we can ask Miklos pull
> from the tree too.  Guys, what do you think?

Sure, since this is not fuse specific, it better not go through my
tree anyway.

Thanks,
Miklos
