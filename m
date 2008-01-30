Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYA3QA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYA3QA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYA3QAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:00:47 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:7571 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYA3QAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c3AWZYFTIro2pClbwvavK73tg4UFB0kUQ/VDWibYw3i49YJajRXuQSRvK9xBRMMCq/nxlVMfvxIKYJD/8dbyTYFSz5Ga0Vg+eu+5knI6msnWDLxOX7FnUYJjqklReEjqthaNqIDT1XR+mx6ELn7K2z87+1qtD/YJLW0BYIRKaak=
Message-ID: <386072610801300800r5dfe3b21l56a0f8a4184842d3@mail.gmail.com>
Date: Thu, 31 Jan 2008 00:00:44 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 1/1] [Scripts] add svn revision information to setlocalversion
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080130102442.GB20846@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201688125-1387-1-git-send-email-bryan.wu@analog.com>
	 <20080130102442.GB20846@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 6:24 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Jan 30, 2008 at 06:15:25PM +0800, Bryan Wu wrote:
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > ---
> >  scripts/setlocalversion |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> > index 52f032e..2d6645c 100644
> > --- a/scripts/setlocalversion
> > +++ b/scripts/setlocalversion
> > @@ -25,6 +25,10 @@ if head=`git rev-parse --verify HEAD 2>/dev/null`; then
> >       # All done with git
> >       exit
> >  fi
> > +# Check for svn and a svn repo.
> > +if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` ; then
> > +        printf -- '-svn%s' $rev
> > +fi
> >
> >  # Check for mercurial and a mercurial repo.
> >  if hgid=`hg id 2>/dev/null`; then
>
> Hi Bryna.
>
> Can I ask you to change the shell script to use
> a chained if so if we find git we do not try mercurial nor svn.
>

Do you mean follow the git and mercurial style to rewrite this svn patch?
No problem I will update it.

> I should have done so initially when adding the patch with mercurial
> support but it slipped my mind.
>

We add svn to this for some time, but I forget to sent it out.
Now I hope it can fix this hole.

Thanks
-Bryan
