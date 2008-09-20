Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYITAze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYITAze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYITAz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:55:26 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34891 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYITAzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:55:25 -0400
Date: Sat, 20 Sep 2008 09:54:54 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919223951.GC11410@amd.com>
References: <20080919220946.GB11410@amd.com>
	<20080920071825A.fujita.tomonori@lab.ntt.co.jp>
	<20080919223951.GC11410@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920095442I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 00:39:51 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 07:18:11AM +0900, FUJITA Tomonori wrote:
> > I don't know it's acceptable if removing the exported interface even
> > if the maintainer of it wants to remove it and it's totally
> > meaningless.
> > 
> > 
> > > reverting is the wrong way. For AMD IOMMU I want to use the
> > > iommu=fullflush way because I want to reuse a parameter thats already
> > > there. Thats why I am against your reverting patch.
> > > So now I stop repeating my points again and again. EOD.
> > 
> > I understood you want to use iommu=fullflush but you can't touch the
> > generic code without any discussion.
> > 
> > And even if everyone is happy about the change, it's much better to
> > start from scratch rather than try to fix the things done in the wrong
> > way.
> 
> Just sleep a night about the discussions for this issue and count then
> how often you changed your opinions and points. It all started with a
> objection from you against 'nofullflush' and ended in that you want to
> explain me the develpment process. And then think again if this
> unimportant minor change was worth all that ridiculous flaming.

Your patch made two changes to the interfaces exported to users, which
we can't change in the future. And they are the changes to the
interface that all IOMMUs can use. Any changes to the interfaces
exported to users are always very important for me because we can't
change or remove them later. I think that we should make such changes
after other developers agree that making the changes is a good idea.

But seems that you have a different opinion about changes to the
interfaces exported to users. Then I can see why we can't agree about
these changes.

If Ingo doesn't marge my patch to revert your changes to the
interfaces exported for users, then I'll fix only 'nofullflush'
option, which is clearly a bad change, as you admitted. I'll move
'nofullflush' back to GART as before. If you think that you can remove
the option, please send your patch to remove it because I don't think
that any changes to the existing exported interface is a good idea and
I just try to fix the problem that your patch introduced. Removing
'nofullflush' is a different topic.
