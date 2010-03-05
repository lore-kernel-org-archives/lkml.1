Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab0CEUHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:07:15 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55245 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab0CEUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:07:13 -0500
Date: Fri, 5 Mar 2010 14:07:03 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com
Subject: Re: [PATCH 1/8] p9auth: set fsuid
Message-ID: <20100305200703.GA29383@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
 <20100225232840.GB24155@kroah.com>
 <20100226040553.GA26170@us.ibm.com>
 <20100226050639.GA6115@kroah.com>
 <20100226181930.GA17850@us.ibm.com>
 <a67e66b21003041404h75d7aacaqb4f3e2a1c97adadc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a67e66b21003041404h75d7aacaqb4f3e2a1c97adadc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ashwin Ganti (ashwin.ganti@gmail.com):
> On Fri, Feb 26, 2010 at 10:19 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> > Ashwin, Ron, Eric, (whoever else cares to take a look) I will put
> > up a git tree hopefully this weekend or monday... hmm, hang on, already
> > exists - you can take a look at
> > http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/p9auth.feb16.3
> >
> 
> Greg/Serge: Sorry for the delay. I am okay with the patches in
> general.  Thanks for making the reaping of old capabilities change as
> well along with these.
> 
> The only comment I have is that it would be nice to have a README file
> in the p9auth directory describing these changes to the semantics.

Will do.

> Especially since we are handling groups, file system checks etc. which
> is going through the capability string, it would be easier and helpful
> to understand if there is some basic documentation on each of these
> changes.
> 
> Also, I don't know if you want to further get them looked by someone

Yeah I'm going to have to re-send and cc: some core maintainers to get
their acks (or nacks).

> more knowledgeable to comment on the implications of modifying/moving
> the set*id functions over but they look alright to me.

If they look ok after I resend them, could you please send an ack I
can tack onto the patches to help out maintainers?

> I have requested Eric too a couple of days ago to take a look at these
> patches if he finds time.

Thanks, I'll give it a few more days to see if he sends comments before
resending.

> Thanks,
> Ashwin

thanks,
-serge
