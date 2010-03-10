Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0CJLvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:51:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0CJLvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:51:15 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC][PATCH 0/2] Correct behavior for listxattr and 'trusted' xattrs
Date: Wed, 10 Mar 2010 12:48:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; i686; ; )
Cc: James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org> <1267621378.3436.15.camel@moss-pluto.epoch.ncsc.mil>
In-Reply-To: <1267621378.3436.15.camel@moss-pluto.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003101248.48385.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 March 2010 14:02:58 Stephen Smalley wrote:
> Should it be using has_capability_noaudit() rather than capable() so
> that merely calling listxattr() on a file that happens to have trusted
> xattrs does not set PF_SUPERPRIV on the task and does not trigger an
> audit message?

Yes, makes sense.  A version of has_capability_noaudit() without an explicit 
task parameter, like security_capable(), would be better still.

Thanks,
Andreas
