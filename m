Return-Path: <linux-kernel-owner+w=401wt.eu-S1764873AbXEYUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764873AbXEYUAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXEYUAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:00:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:35253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbXEYUAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:00:36 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Fri, 25 May 2007 22:00:21 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <267570.85171.qm@web36604.mail.mud.yahoo.com>
In-Reply-To: <267570.85171.qm@web36604.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705252200.21765.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 19:43, Casey Schaufler wrote:
> [...] but the AppArmor code could certainly check for that in exec by
> enforcing the argv[0] convention. It would be perfectly reasonable for a
> system that is so dependent on pathnames to require that.

Hmm ... that's a strange idea. AppArmor cannot assume anything about argv[0], 
and it would be a really bad idea to change the well-established semantics of 
argv[0].

There is no actual need for looking at argv[0], though: AppArmor decides based 
on the actual pathname of the executable...

Thanks,
Andreas
