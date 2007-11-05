Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbXKEN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbXKEN3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 08:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbXKEN3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 08:29:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46123 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbXKEN3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 08:29:12 -0500
Date: Mon, 5 Nov 2007 07:29:06 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: Peter Dolding <oiaohm@gmail.com>, casey@schaufler-ca.com,
       Toshiharu Harada <haradats@gmail.com>,
       Crispin Cowan <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071105132906.GA26078@sergelap.austin.ibm.com>
References: <e7d8f83e0710311904w45827586oabcca597fd612ea6@mail.gmail.com> <832119.21078.qm@web36614.mail.mud.yahoo.com> <e7d8f83e0710311951nd162a27rb2134e3b21e299a8@mail.gmail.com> <472EBE87.1050106@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472EBE87.1050106@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Peter Dolding wrote:
> > On 11/1/07, Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> --- Peter Dolding <oiaohm@gmail.com> wrote:
> >> Posix capabilities predate SELinux. SELinux is not interested in
> >> Posix capabilities.
> >>
> >>> But no IBM had to do it.
> >> Err, no. It was done by Andrew Morgan back in the dark ages.
> >> Why on earth do you think IBM did it?
> > 
> > Posix file capabilities the option to replace SUID bit with something
> > more security safe only handing out segments of root power instead of
> > the complete box and dice like SUID.  Even different on a user by user
> > base.
> > 
> > Posix capabilites is what Posix file capabilities is based on.  Yes I
> > know the words appear close.  The word file is important.  Please read
> > Website.  http://www.ibm.com/developerworks/linux/library/l-posixcap.html
> 
> For the record, I think you are both right. I took a stab at it back
> when Casey and I first met:
> 
> ftp://ftp.kernel.org/pub/linux/libs/security/linux-privs/old/kernel-2.4-fcap/README
> 
> all that stuff worked fine it was just a bit ahead of its time...
> 
> - From memory, at that point in time "extended attributes" were an
> external patch, and having some trouble getting merged. My sense was
> that EA was a pre-requisite and I was happy to wait for that support to
> become integrated before pushing my file capability support.
> 
> In the midst of all this LSM emerged as a reaction to Linus' clear
> unhappiness about all extensions security. I didn't have the time to
> participate in the LSM, and my work sat in the form of these patches.
> 
> SELinux at that time existed as a separate infrastructure, and evidently
> did have the time to embrace LSM.
> 
> > IBM coders worked and got it into the main line really recently to
> > provide at least some way to avoid fault of SUID of course it could
> 
> [...]
> 
> So, yes, IBM (Serge) deserve full credit for starting over, and getting
> it merged...

There are still pieces to line up.  Note that Andrew Morgan is working
on a patch to make the securebits per-process to make capabilities
more useful as well as a 64-bit capability patch.  And the support in
tree to date would be riddled with gotchas without Andrew Morgan's,
Stephen Smalley's, and Casey Schaufler's input.

-serge

(But hey, thanks :)
