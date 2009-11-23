Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZKWVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZKWVuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZKWVuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:50:44 -0500
Received: from tundra.namei.org ([65.99.196.166]:41822 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZKWVun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:50:43 -0500
Date: Tue, 24 Nov 2009 08:50:44 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LSM: Move security_path_chmod()/security_path_chown()
 to after mutex_lock().
In-Reply-To: <4B0A5F6E.2080400@canonical.com>
Message-ID: <alpine.LRH.2.00.0911240850310.28250@tundra.namei.org>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091004125327.105675949@I-love.SAKURA.ne.jp> <20091029051211.GB11558@us.ibm.com> <200910300056.IFD65194.MSOLHFOVJQtOFF@I-love.SAKURA.ne.jp> <200911221149.HCF73996.FSLtOOHVJFQOFM@I-love.SAKURA.ne.jp>
 <4B0A5F6E.2080400@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, John Johansen wrote:

> Tetsuo Handa wrote:
> > [PATCH] LSM: Move security_path_chmod()/security_path_chown() to after mutex_lock().
> > 
> > We should call security_path_chmod()/security_path_chown() after mutex_lock()
> > in order to avoid races.
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> Acked-by: John Johansen <john.johansen@canonical.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
