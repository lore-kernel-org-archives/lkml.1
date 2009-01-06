Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZAFXP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZAFXP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZAFXPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:15:46 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:55195 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZAFXPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:15:45 -0500
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <m1eizg11fy.fsf@frodo.ebiederm.org>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com>  <m1eizg11fy.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 18:15:34 -0500
Message-Id: <1231283734.8041.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 52956E9E0AEBE3D0FFF9EFC0BD4B856847DA7890
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 328 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 15:04 -0800, Eric W. Biederman wrote:
> That implies to me you want to capture the value at mount time, and to
> pass it in to the rpc_call creation, and only at very specific well
> defined points where we interact with user space should we examine
> current->utsname().  At which point there should be no question
> of current->utsname() is valid as the user space process is alive.

Why pretend that the filesystem is owned by a particular namespace? It
can, and will be shared among many containers...

Trond

