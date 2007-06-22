Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbXFVFX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbXFVFX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXFVFXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:23:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36418 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXFVFXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:23:19 -0400
Date: Fri, 22 Jun 2007 06:23:15 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070622052315.GU21478@ftp.linux.org.uk>
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com> <or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br> <20070622013417.GT21478@ftp.linux.org.uk> <or1wg4hawh.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or1wg4hawh.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 01:26:54AM -0300, Alexandre Oliva wrote:
> On Jun 21, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > On Thu, Jun 21, 2007 at 10:00:22PM -0300, Alexandre Oliva wrote:
> >> Do you agree that if there's any single contributor who thinks it
> >> can't be tivoized, and he manages his opinion to prevail in court
> >> against a copyright holder, then it can't?  That this is the same
> >> privilege to veto additional permissions that Al Viro has just
> >> claimed?
> 
> > You know, I'm rapidly losing any respect for your integrity.  The only
> > "privelege" claimed is that of not relicensing one's contributions.
> 
> No, this thread was about additional permissions to combine with other
> licenses.  I didn't suggest anything about relicensing whatsoever,
> that's all noise out of not understanding the suggestion.

And that constitutes the change of license.  If you *really* do not understand
that, I'd recommend asking FSF legal folks, especially since you have
mentioned working on v3.  And that, BTW, is far more serious detail than
your affiliation (or lack thereof) with FSF.  Don't forget to bring a copy
of your posting that had started this thread when you talk to them.

And really, stop digging.  Please.  YANAL.  You are definitely not in
position to offer any specific changes in v3.  Are you seriously expecting
an ACK on your handwaving, when conditions mentioned in your patch to
license are not just vague as hell, but are 100% certain to be interpreted
in conflicting ways as shown by the previous thread?

What are you expecting, anyway?  "You guys can link to v3 code if you read
v2 as prohibiting tivoization, otherwise the code is withdrawn" != "some
people think that v2 prohibits it, some do not".  And somehow I doubt that
this change of situation will make the latter happy.

Besides, what you are suggesting is logistical nightmare.  Somebody in
v3 project changes borrowed v2 code.  Result is pulled back into Linux.
What is the license of that thing?  v3 with additional permission?  v2
with additional permission?  What happens if code is then rewritten, with
some pieces remaining from v3 changes?  Oh, you want to deal only with
entire modules?  And then both sides need to be damn careful not to copy
pieces across the module boundary?

Suppose ZFS _is_ pulled into the tree via that mechanism.  Just what
will happen if some code is massaged a bit, found generically useful
and lifted into a helper function?  Do other filesystems (v2 ones)
calling it suddenly get into patent violations?

Just what makes you think that anybody would like that kind of "cooperation"?
