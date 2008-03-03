Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbYCCKHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbYCCKHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYCCKHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:07:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:60958 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYCCKHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iMDAuG3AWDxy5trKfef0ljktv4xGYwZngWv6ac6uAKxLdaQ+qHgPofW6VbQ283Sv1/zu25+jCpaqWzRSFOQXLRBSV0rqCizR55/3d/t7g2rYrcM18O0u9Pv48VhjyP2nUdHolapXWjyNdU98UXlo3ac5jGeF3jPmL2r0g/DAgkI=
Message-ID: <cfd18e0f0803030207j73da3172mf9470859bb918546@mail.gmail.com>
Date: Mon, 3 Mar 2008 11:07:06 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080303092422.GA18281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
	 <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
> > On Mon, Mar 3, 2008 at 8:33 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > > If we don't have any man page, what is the actual definition of
> > > > SCHED_IDLE anyway?
> > >
> > > it's rather simple: "it's a priority level even lower priority than nice
> > > +19".
> >
> > Some other questions whose answers may be worth including in the man page:
> >
> > * When was SCHED_IDLE added?  (Actually, who added it?)
>
> "git-blame include/linux/sched.h" gives you that information, it was
> added by me as part of CFS:
>
>  commit 0e6aca43e08a62a48d6770e9a159dbec167bf4c6
>  Author: Ingo Molnar <mingo@elte.hu>
>  Date:   Mon Jul 9 18:51:57 2007 +0200

Yep -- I found it later -- thanks.

Ingo, could you please CC me when kernel-userland API changes go into
mainline?  Otherwise, they potentially end up undocumented, and
un(der)used.

Thanks,

Michael


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
