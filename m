Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZJLBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZJLBFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 21:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZJLBFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 21:05:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:36114 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZJLBFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 21:05:23 -0400
Date: Mon, 12 Oct 2009 12:04:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 01/25] LSM: Add security_path_chmod() and
 security_path_chown().
In-Reply-To: <4ACE1CFE.3020507@canonical.com>
Message-ID: <alpine.LRH.2.00.0910121203090.19066@tundra.namei.org>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091004125327.105675949@I-love.SAKURA.ne.jp> <4ACE1CFE.3020507@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, John Johansen wrote:

> Tetsuo Handa wrote:
> > This patch allows pathname based LSM modules to check chmod()/chown()
> > operations. Since notify_change() does not receive "struct vfsmount *",
> > we add security_path_chmod() and security_path_chown() to the caller of
> > notify_change().
> >
> > These hooks are used by TOMOYO.
> 
> This hooks would be useful for AppArmor as well.


I've applied the first three patches to 

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

It would be good to see some more evidence of review for the remaining 
patches.


-- 
James Morris 
<jmorris@namei.org>

