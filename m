Return-Path: <linux-kernel-owner+w=401wt.eu-S1031124AbXDQQKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031124AbXDQQKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031123AbXDQQKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:10:18 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:34098 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031121AbXDQQKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:10:16 -0400
To: serue@us.ibm.com
CC: akpm@linux-foundation.org, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <20070417143301.GH1442@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 05/10] Add "permit user submounts" flag to vfsmount
References: <20070416110308.739051445@szeredi.hu> <20070416110414.591968270@szeredi.hu> <20070416192050.GB30435@sergelap.austin.ibm.com> <E1HdlAt-00013a-00@dorka.pomaz.szeredi.hu> <20070417143301.GH1442@sergelap.austin.ibm.com>
Message-Id: <E1HdqEF-00020e-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Apr 2007 18:08:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > MNT_USER and MNT_USERMNT?  I claim no way will people keep those
> > > straight.  How about MNT_ALLOWUSER and MNT_USER?
> > 
> > Umm, is "allowuser" more clear than "usermnt"?  What is allowed to the
> 
> I think so, yes.  One makes it clear that we're talking about allowing
> user (somethings :), one might just as well mean "this is a user mount."
> 
> > user?  "allowusermnt" may be more descriptive, but it's a bit too
> > long.
> 
> Yes, if it weren't too long it would by far have been my preference.
> Maybe despite the length we should still go with it...
> 
> > I don't think it matters all that much, the user will have to look up
> > the semantics in the manpage anyway.  Is "nosuid" descriptive?  Not
> > very much, but we got used to it.
> 
> nosuid is quite clear.

Is it?  Shouldn't these be "allowsuid", "noallowsuid", "allowexec",
"noallowexec"?

See, we mentally add the "allow" quite easily.

> MNT_USER and MNT_USERMNT are so confusing that in the time I go from
> quitting the manpage to foregrounding my editor, I may have already
> forgotten which was which.

Well, to the user they are always in the form "user=123" and
"usermnt", so they are not as easy to confuse.

But I feel a bit stupid bickering about this, because it isn't so
important.  "allowuser" or "allowusermnt" are fine by me if you think
they are substantially better than "usermnt".

Miklos
