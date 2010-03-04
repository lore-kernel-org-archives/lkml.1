Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0CDWEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:04:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37511 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0CDWEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:04:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lFjZKd0Hb8xwa5tYasEGgNuTkI124N12frTb+CwZs1HIIGbnJ17sy3F6eyD0W759ft
         vU404WQSTzdPAb3nSXjx+L3qWoX1ZtIbEssP6BxRAtkEg956QBnwxGsNj1hBVunMkWbc
         V5JtoFnQlBTrJoHX4EqHAFyj3J4UkGK/GhzVQ=
MIME-Version: 1.0
In-Reply-To: <20100226181930.GA17850@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
	 <20100225232840.GB24155@kroah.com> <20100226040553.GA26170@us.ibm.com>
	 <20100226050639.GA6115@kroah.com> <20100226181930.GA17850@us.ibm.com>
Date: Thu, 4 Mar 2010 14:04:10 -0800
Message-ID: <a67e66b21003041404h75d7aacaqb4f3e2a1c97adadc@mail.gmail.com>
Subject: Re: [PATCH 1/8] p9auth: set fsuid
From: Ashwin Ganti <ashwin.ganti@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:19 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Ashwin, Ron, Eric, (whoever else cares to take a look) I will put
> up a git tree hopefully this weekend or monday... hmm, hang on, already
> exists - you can take a look at
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/p9auth.feb16.3
>

Greg/Serge: Sorry for the delay. I am okay with the patches in
general.  Thanks for making the reaping of old capabilities change as
well along with these.

The only comment I have is that it would be nice to have a README file
in the p9auth directory describing these changes to the semantics.
Especially since we are handling groups, file system checks etc. which
is going through the capability string, it would be easier and helpful
to understand if there is some basic documentation on each of these
changes.

Also, I don't know if you want to further get them looked by someone
more knowledgeable to comment on the implications of modifying/moving
the set*id functions over but they look alright to me.

I have requested Eric too a couple of days ago to take a look at these
patches if he finds time.

Thanks,
Ashwin
