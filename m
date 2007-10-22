Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbXJVCZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbXJVCZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXJVCZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:25:03 -0400
Received: from ruby.spiritone.com ([216.99.193.130]:57238 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbXJVCZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:25:00 -0400
Date: Sun, 21 Oct 2007 19:24:42 -0700
Message-Id: <200710220224.l9M2Og5t020815@sapphire.spiritone.com>
From: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
To: "Crispin Cowan" <crispin@crispincowan.com>
Cc: linux-kernel@vger.kernel.org,
       "LSM ML" <linux-security-module@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Reply-To: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
Subject: Re: LSM conversion to static interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I think Crispin has succinctly summed it up:  irrevocably closing
the LSM prevents commercial customers from using security modules other
than that provided by their Linux distributor.  As Sarbanes-Oxley and
other regulatory laws require these customers to use "standard
kernels", the result is a rather dreary form of vendor lock-in, where the
security framework is coupled to the distribution.

Though it would require a somewhat undesirable complexity of CONFIG_
flags, it should be possible to construct flexibility enough for everyone
to get what he wants.  For example, it should be possible to configure
kernels with a single security framework hard-linked, AND it should
also be possible to configure kernels such that the default security
framework could be completely replaced at boot time by another, be it
out-of-tree module, or other.

I agree entirely that preserving this form of freedom for the end user
makes Linux a much stronger technology than not.  For one thing, the
consequences of closing LSM are fairly certain to irritate enterprise
commercial customers, which is probably a sign that the technology has
taken a wrong turn.

Tommy F.


Crispin Cowan <crispin@crispincowan.com> wrote:

> So the net impact of this patch is:
> 
>    * It takes a deployment practice (static compiled-in security) that
>      is arguably good in many circumstances and makes it mandatory at
>      all times.
>    * It takes a development practice that is very convenient and
>      slightly risky, and forces you into the pessimal inconvenient
>      development practice at all times.
>    * It prevents enterprise users, and in fact anyone who isn't
>      comfortable compiling their own kernel, from ever trying out any
>      security module that their distro vendor of choice did not ship.
>
> This strikes me as a rather anti-choice position to take. It says that
> because candy is bad for you, you only ever get to eat vegetables. I
> don't understand why Linux would want to do this to its users.
>
> It doesn't hurt me or AppArmor. Since AppArmor is now shipping with
> SUSE, Ubuntu, and Mandriva, what this does is make it harder for newer
> modules like TOMOYO, Multi-Admin, etc, to get exposure to enterprise
> users. So I don't think I am being self-serving in arguing against this
> patch. I just think it is bad for Linux.
>
> Crispin
>
> -- 
> Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
>         Itanium. Vista. GPLv3. Complexity at work

