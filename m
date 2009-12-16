Return-Path: <linux-kernel-owner+w=401wt.eu-S935858AbZLPWlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858AbZLPWlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935847AbZLPWlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:41:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35999 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935158AbZLPWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:41:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=vvds3ECtJH9V1Bih/exle60y8jzBRTid78d5Rk5GqelmeqCnWcT0H1rdJdjecAW26o
         Xas6u1SsvAsLr3NvfaT3BZTk06i8vnAbEONWvcyo/NgF//7GFEpDudf79ydSL8Ohdgd3
         VqDDQqtCyOTz6LStmDlPOxa2xwZ/CtEpON3Mg=
Date: Wed, 16 Dec 2009 23:41:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc0: reiserfs: inconsistent lock state
Message-ID: <20091216224117.GA5014@nowhere>
References: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com> <20091214110921.GA5168@nowhere> <a4423d670912141211q3e63011ftfd526ec541b09d44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670912141211q3e63011ftfd526ec541b09d44@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:11:35PM +0300, Alexander Beregalov wrote:
> 2009/12/14 Frederic Weisbecker <fweisbec@gmail.com>:
> > On Sat, Dec 12, 2009 at 01:06:29AM +0300, Alexander Beregalov wrote:
> >> Hi Frederic
> >>
> >> It is x86_32 UP
> >>
> >>
> >> [ INFO: inconsistent lock state ]
> >> 2.6.32-05594-g3ef884b #2
> > [...]
> >
> >
> > Thanks! I've pushed two fixes in my tree. May be could
> > you test them by merging it on latest upstream?
> >
> > As usual, it's on:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> >        reiserfs/kill-bkl
> 
> Thanks, I'm going to test it.
> 
> Another piece of work for you. You should hate me.


Not really, I much prefer to see your reports and fix them than later
try to find sources of obscure soft lockups from users reports :)


> 
> [ INFO: possible circular locking dependency detected ]
> 2.6.32-06793-gf405425-dirty #2


I've sent a patch in another answer of this report,
hopefully that fixes the issue. I've also pushed it out
in my tree with the two others.

Thanks!

