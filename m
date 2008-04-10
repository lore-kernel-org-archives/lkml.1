Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYDJMRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYDJMRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYDJMRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:17:43 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53408 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbYDJMRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:17:42 -0400
Date: Thu, 10 Apr 2008 06:17:25 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@zeniv.linux.org.uk, miklos@szeredi.hu, ezk@cs.sunysb.edu,
       akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Call LSM functions outside VFS helper functions.
Message-ID: <20080410121725.GP11962@parisc-linux.org>
References: <200804090053.m390rE9k007085@agora.fsl.cs.sunysb.edu> <E1Jjug8-0006a2-Vs@pomaz-ex.szeredi.hu> <200804102102.JFI05247.OVJOFHFStLOFQM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804102102.JFI05247.OVJOFHFStLOFQM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 09:02:57PM +0900, Tetsuo Handa wrote:
> If the conclusion became "vfsmount should not be passed to
> VFS helper functions", that's OK, but I want you to consider
> the below approach for AppArmor and TOMOYO Linux. This patch is a repost of
> http://kerneltrap.org/mailarchive/linux-fsdevel/2008/2/17/882024 .

I'm a little disappointed that you simply repost this patch rather than
responding to my post from yesterday:

> How about an approach which doesn't require the vfsmount to be passed
> down?
> 
> When the rule is put in place, say "No modifications to /etc/passwd",
> look up the inode and major:minor of /etc/passwd.  If there's a rename,
> look up the new inode number.  If it's mounted elsewhere, it doesn't
> matter, they still can't modify it because it has the same
> major:minor:inode.
> 
> Is this workable?

Could you respond to this please?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
