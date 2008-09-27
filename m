Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYI0Nng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYI0Nng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 09:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYI0Nn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 09:43:29 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39188 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYI0Nn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 09:43:28 -0400
Date: Sat, 27 Sep 2008 08:43:07 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] file capabilities: clean up setcap code
Message-ID: <20080927134307.GA11943@us.ibm.com>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com> <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com> <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com> <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com> <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com> <48DDBD6E.1070108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DDBD6E.1070108@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge,
> 
> I have to say I'm a bit confused by this one. Specifically, the
> cap_get_target_pid() change. In your 5/6 patch, you say this change
> ("the previous patch") makes the kernel bigger? Is this because of the
> cap_get_target_pid() changes? Since you are fighting to reduce space, if
> it bloats the code does the cap_get_target_pid() part of the change make
> sense?

Yes I think it does.  Yes my goal was to decrease the kernel size, but
having cleaner code - and getting rid of dead codepaths - is more
important.

It may be hard to tell by looking at the patch, but I think the
end-result is really far better.

thanks,
-serge
