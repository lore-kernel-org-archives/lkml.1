Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXJHTwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXJHTwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXJHTwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:52:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50618 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXJHTwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:52:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
	<4702B1D5.5050502@tmr.com>
	<alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
	<4703126D.70703@tmr.com>
	<alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>
	<m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
	<15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
	<m1zlyymaoy.fsf@ebiederm.dsl.xmission.com>
	<20071008160611.GA7106@vino.hallyn.com>
	<m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>
	<20071008180038.GC7106@vino.hallyn.com>
Date: Mon, 08 Oct 2007 13:50:58 -0600
In-Reply-To: <20071008180038.GC7106@vino.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 8 Oct 2007 13:00:38 -0500")
Message-ID: <m1hcl11j31.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> It really seems to me that the LSM as currently structured creates
>> a large barrier to entry for people who have just this little thing
>> they want to do that is not possible with any existing security
>> module.
>
> Yes and it's been made increasingly so far particularly because of the
> perceived potential for 'abuse'.  So to be curt, allowing people like
> you describe to do something small and interesting is deemed far less
> important than making sure that the small thing they want to do fits
> within the LSM mandate and is not a non-upstream module.
>
> So that is the concern you would need to address before any other.
>
> Still, I do think that selinux policy modules may do just what you want.
> The main obstacle appears to be that the 'base' policy is so huge that
> it's tough to get started to do something small.
>
> You also might want to check out LIDS, as its rules are set up pretty
> much the way you seem to want.

To be very clear.  Enhancing the LSM is of interest to me as it looks
like that is a way to get people working and playing well together,
and that ultimately to be able to run a full distro in a container
I'm going to need this ability.

Examples of better ways to do this in selinux, LIDS, or SMACK are only
interesting as far as they suggest how to enhance the LSM.

I honestly think enhancing the LSM would actually reduce it's ability
to be abused, because nothing would directly own the hook.

My very practical question:  How do I run selinux in one container,
and SMACK in another?

Eric
