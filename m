Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbYEFTPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbYEFTPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbYEFTPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:15:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:61083 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbYEFTPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DmerptUQuqLnumANyJ7wlD/ge84Lf/xSNZ/Lu3IxeLYtsOVA1+2s5bUHgbZpnYnJ8m8GmrOUKtxeF2ArInFVLE5Bf4sT0n4LoLH47YBN9TJe+rIW54PYQOOhPz7ENHP4e+YQtYEJAr/CTmpmQdpl1VPGvKFPjtC+NuEMk1JCs0c=
Message-ID: <86802c440805061215x22ca5572ofb0297b60e4ffd26@mail.gmail.com>
Date: Tue, 6 May 2008 12:15:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fixed mtrr change WP to WB
Cc: "Ingo Molnar" <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4820ACB5.9060009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805061038.58023.yhlu.kernel@gmail.com>
	 <200805061041.40047.yhlu.kernel@gmail.com>
	 <482099E6.5060208@zytor.com>
	 <86802c440805061124w630bc987k71c3c290fdfde773@mail.gmail.com>
	 <4820A401.1040105@zytor.com>
	 <86802c440805061134y21fbb2a3s872c41c522b9f49f@mail.gmail.com>
	 <4820A6DF.7010607@zytor.com>
	 <86802c440805061205lf312e02jb44318e97212d4e1@mail.gmail.com>
	 <4820ACB5.9060009@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 12:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > >
> > > >
> > > >
> > >  Then you would have to add a method to pass it into the kernel if you
> want
> > > it to be generally useful.
> > >
> >
> > but how about old stock kernel in RHEL3U9?
> >
> >
>
>  There is nothing you can do about those that will work on any platform.  If
> you have knowledge of the firmware you can of course break those rules.
>
thanks. I will try to allocate 4k page for mpc and copy the old mpc to
it..., and reuse the old mpf.

YH
