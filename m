Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXDQOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXDQOdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030413AbXDQOdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:33:18 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33702 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030370AbXDQOdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:33:16 -0400
Date: Tue, 17 Apr 2007 09:33:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 05/10] Add "permit user submounts" flag to vfsmount
Message-ID: <20070417143301.GH1442@sergelap.austin.ibm.com>
References: <20070416110308.739051445@szeredi.hu> <20070416110414.591968270@szeredi.hu> <20070416192050.GB30435@sergelap.austin.ibm.com> <E1HdlAt-00013a-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HdlAt-00013a-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > If MNT_USERMNT flag is not set in the target vfsmount, then
> > 
> > MNT_USER and MNT_USERMNT?  I claim no way will people keep those
> > straight.  How about MNT_ALLOWUSER and MNT_USER?
> 
> Umm, is "allowuser" more clear than "usermnt"?  What is allowed to the

I think so, yes.  One makes it clear that we're talking about allowing
user (somethings :), one might just as well mean "this is a user mount."

> user?  "allowusermnt" may be more descriptive, but it's a bit too
> long.

Yes, if it weren't too long it would by far have been my preference.
Maybe despite the length we should still go with it...

> I don't think it matters all that much, the user will have to look up
> the semantics in the manpage anyway.  Is "nosuid" descriptive?  Not
> very much, but we got used to it.

nosuid is quite clear.  MNT_USER and MNT_USERMNT are so confusing that
in the time I go from quitting the manpage to foregrounding my editor, I
may have already forgotten which was which.

-serge
