Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbXGWSGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbXGWSGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762848AbXGWSF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:05:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:6678 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbXGWSFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mB521H5uNY+RyHthOSlXzoeS/sqGn9tlIjHMe/CznJ+A7A+0iJAl7xBqU3LISAEq95Y2ICndypw+KqCvagkw4CdEcoA32kBXBox9YCLi3sAWZgzEhroJXrq83Oz3kMy/OF6NIQdFuC5sa31GASL9d4DN3jeuDZVf974O64QXYPk=
Message-ID: <f158dc670707231105o18fa3f63j194285547493f04a@mail.gmail.com>
Date: Mon, 23 Jul 2007 12:05:53 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: CTL_UNNUMBERED (Re: [PATCH] 9p: Don't use binary sysctl numbers.)
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <a4e6962a0707231013v47683cd0xd35c65c25cb40653@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com>
	 <20070721205709.GB5772@martell.zuzino.mipt.ru>
	 <m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
	 <a4e6962a0707231013v47683cd0xd35c65c25cb40653@mail.gmail.com>
X-Google-Sender-Auth: f892192902498187
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't really matter (for me) whether it is sysctl or sysfs
interface. The sysctl approach seemed easier to implement. If the
consensus is to use sysfs, I'll send a patch (for 2.6.24).

Sorry for the incorrect implementation, I guess I stole the code from
unappropriate place :)

Thanks,
    Lucho

On 7/23/07, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On 7/21/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Alexey Dobriyan <adobriyan@gmail.com> writes:
> >
> > >
> > > That's separate patch but CTL_UNNUMBERED must die, because it's totally
> > > unneeded. If you don't want sysctl(2) interface just SKIP ->ctl_name
> > > initialization and save one line for something useful.
> >
> > As for the 9p code it doesn't seem to need or want a real binary
> > interface.  The 9p debug code picking of a semi-random number and not
> > patching it into sysctl.h like it should for a binary interface is
> > an implementation bug, and a maintenance problem.
> >
>
> Now that -rc1 is out, lets talk a bit more about this.  Lucho can you
> provide some level of justification of why you went for a sysctl
> interface versus something directly accessible within the file system
> -- that would seem more on-par with the 9p philosophy.
>
> Perhaps its time for a general cleanup of the debug_level stuff -- it
> was always ugly to have it as a global, but there was just no clear
> way to have the session structure available everywhere we use it.
>
>                -eric
>
