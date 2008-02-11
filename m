Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYBKSKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYBKSKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbYBKSKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:10:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYBKSKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ucuEeMI9dW24dj7r/E7P5XTplhQjHI5eVK0REltHMLXsPC21f7p+j8SbznOmYno/d1pExWLiBdChnyjvHwqxfXCY1cUd4+ixe6hZ33jiZwrVgTCabfq5Vi6P2GO18msSKWP3Er7C2v6e5TBnqIcnvrPZ/QGOtrRJzTfct+oA0nc=
Date: Mon, 11 Feb 2008 19:09:55 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
Message-ID: <20080211180950.GA6136@joi>
References: <20080210143240.GA13317@joi> <20080211102339.GD11671@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211102339.GD11671@shadowen.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 10:23:39AM +0000, Andy Whitcroft wrote:
> On Sun, Feb 10, 2008 at 03:33:02PM +0100, Marcin Slusarz wrote:
> > Hi
> > 
> > Checkpatch in current mainline outputs following errors:
> > 
> > $ ./scripts/checkpatch.pl -q --file ./fs/udf/misc.c
> > ERROR: need consistent spacing around '*' (ctx:WxV)
> > #205: FILE: fs/udf/misc.c:205:
> > +       tag *tag_p;
> >             ^
> > 
> > $ ./scripts/checkpatch.pl -q --file ./fs/udf/unicode.c
> > ERROR: need consistent spacing around '*' (ctx:WxV)
> > #48: FILE: fs/udf/unicode.c:48:
> > +int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
> >                                                ^
> > (...)
> > 
> > I think the code is ok.
> 
> Yep the code is clearly correct.  Can I have the whole patch fragment
> you got these against so I can figure out why we are unable to detect
> these two as types, I would expect us to have done so.  Also what
> version of checkpatch is this?  There is a version string at the top.
It's current Linus git tree (both checkpatch and "testcase").

Marcin
