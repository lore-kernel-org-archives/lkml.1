Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYDWOgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYDWOgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYDWOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:36:20 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49943 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYDWOgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:36:20 -0400
Date: Wed, 23 Apr 2008 09:36:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Containers <containers@lists.osdl.org>, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
Message-ID: <20080423143610.GA13718@sergelap.austin.ibm.com>
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com> <1207779313.16926.12.camel@x61.ebiederm.org> <20080410015955.GA18227@sergelap.austin.rr.com> <1207812980.7509.25.camel@x61.ebiederm.org> <20080422142539.GA12623@sergelap.austin.ibm.com> <m1hcdtsovg.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hcdtsovg.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> >> 
> >> I'm hoping to be able to get back at this in the week or so as things
> >> settle down from my move.  My last patches should be in my proof of
> >> concept network namespace tree, if they don't show up elsewhere.
> >
> > Is that the tree I'd get from
> >
> > git-fetch
> > git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-netns.git
> > master:ebieder.master
> 
> Yes.
> 
> > ?  So I'd add a user_ns to the struct sysfs_tag_info?
> >
> > If so I'll give it a whirl.
> 
> Sounds good.  My apologies I keep being almost on the verge
> of getting someplace.

Ok I've got the sysfs relevant patches ported to 2.6.25, and am looking
at how to extend it to handle /sys/kernel/uids.  You have tagging tied
intimately to struct class.  So the question is should I generalize the
taggint to deal with kobjects instead, or create a struct class user
and make /sys/kernel/uids a symlink to /sys/class/user/uids?

Opinions?

thanks,
-serge

PS: If you want me to post the patchset before handling userns I can do
that, otherwise I was just going to wait until I'm done with userns.

