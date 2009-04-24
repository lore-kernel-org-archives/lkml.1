Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZDXTjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZDXTjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZDXTiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:38:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35367 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZDXTiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Fs6ome+lVoVJWjKL5k8iWsYeT4PQzM2X9pjhEbdXHJZ1t/VfjuaaTK1etisRXmnumC
         RbF7AQOAZ1EUM98LjKC3uyu4aYROFwVZa6vFHYFWuN51i0DZTLkvsNS/36t4Ytfe2Q7A
         DPRmQo6KS8daItPt3cFlY+yhShhO10HuZJt4E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] MAINTAINERS: update IDE entry
Date: Fri, 24 Apr 2009 21:21:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904232248.31735.bzolnier@gmail.com> <200904241154.04860.bzolnier@gmail.com> <9ea470500904240941s53f41b2dq1c4e5bc85b6244d7@mail.gmail.com>
In-Reply-To: <9ea470500904240941s53f41b2dq1c4e5bc85b6244d7@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904242121.16910.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 April 2009 18:41:42 Borislav Petkov wrote:
> Hi,
> 
> On Fri, Apr 24, 2009 at 11:54 AM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Friday 24 April 2009 10:08:48 Sergei Shtylyov wrote:
> >> Hello.
> >>
> >> Bartlomiej Zolnierkiewicz wrote:
> >>
> >> > By a popular demand quilt tree was replaced by a git one.
> >> >
> >> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> > ---
> >> >  MAINTAINERS |    2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > Index: b/MAINTAINERS
> >> > ===================================================================
> >> > --- a/MAINTAINERS
> >> > +++ b/MAINTAINERS
> >> > @@ -2743,7 +2743,7 @@ IDE SUBSYSTEM
> >> >  P: Bartlomiej Zolnierkiewicz
> >> >  M: bzolnier@gmail.com
> >> >  L: linux-ide@vger.kernel.org
> >> > -T: quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
> >> > +T: git git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
> >> >
> >>
> >>   Does that mean that the patches that have been already accepeted into
> >> the git tree, can't be updated afterwards (i.e. I have a habit of
> >> sometimes sending several takes of the same patch)?
> >
> > Yes, please just send incremental updates once the patch has been merged.
> 
> Or, you can interactively rebase the tree to the commit right before the patch
> to be replaced and then add the updated patch in place of the old one. There's a
> very hands-on example in the manpage in section "INTERACTIVE MODE."
> 
> A problem with that might be that others who've pulled from your branch will see
> the rewritten history with a new SHA1 commit, but that would be still ok since
> we'll be pulling from the linux-next branch and the for-linus branch is the one
> that is cast in stone once Linus pulls from you.

I don't think that it will be ok to people who have already based their
work on a earlier version of the tree.  Also sometimes people may need
to pull ide tree into their tree (block tree comes to mind) so rebasing
should be avoided as much as possible.

Moreover, I would prefer getting patches which don't need updating. ;-)

Thanks,
Bart
