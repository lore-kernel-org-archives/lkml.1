Return-Path: <linux-kernel-owner+w=401wt.eu-S1766970AbXDSTkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766970AbXDSTkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766971AbXDSTkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:40:47 -0400
Received: from mail.fieldses.org ([66.93.2.214]:37516 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766970AbXDSTkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:40:46 -0400
Date: Thu, 19 Apr 2007 15:40:36 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: David Brown <dmlb2000@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL] kvm oops fix
Message-ID: <20070419194036.GL9101@fieldses.org>
References: <1176997839110-git-send-email-avi@qumranet.com> <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org> <4627BE6B.8030006@garzik.org> <9c21eeae0704191224g104f4an96b330c6b77c29a7@mail.gmail.com> <4627C429.2020500@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4627C429.2020500@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 03:34:01PM -0400, Jeff Garzik wrote:
> David Brown wrote:
> >>What is the easiest way to completely undo a pull, reverting the branch
> >>to the HEAD present before the pull?
> >>
> >
> >If the pull doesn't merge successfully then usually doing a `git-reset
> >--hard` will blow everything away back to normal, but Linus may do
> >different things.
> 
> I'm thinking about a successful pull that one later regrets :)

git reset --hard ORIG_HEAD, if the pull is the last thing you did.

Otherwise maybe fire up gitk, look for the point you'd like to revert
to, and cut-n-paste the SHA1 ID to the git reset --hard commandline.

--b.
