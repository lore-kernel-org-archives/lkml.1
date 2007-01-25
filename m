Return-Path: <linux-kernel-owner+w=401wt.eu-S965033AbXAYPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbXAYPcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965515AbXAYPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:32:45 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44052 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965510AbXAYPco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:32:44 -0500
Date: Thu, 25 Jan 2007 09:32:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org
Subject: Re: [PATCH 7/8] user ns: handle file sigio
Message-ID: <20070125153239.GA17904@sergelap.austin.ibm.com>
References: <20061219225902.GA25904@sergelap.austin.ibm.com> <20061219230127.GH25904@sergelap.austin.ibm.com> <m1zm881gq4.fsf@ebiederm.dsl.xmission.com> <20070124185845.GA597@sergelap.austin.ibm.com> <20070125001253.75f899d6.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125001253.75f899d6.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@osdl.org):
> On Wed, 24 Jan 2007 12:58:45 -0600
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > > If we need to I can see doing something special if the process setting
> > > fown has CAP_KILL
> > 
> > Obviously CAP_KILL is insufficient :)  I assume you mean a new
> > CAP_XNS_CAP_KILL?
> > 
> > > and bypassing the security checks that way, but
> > > hard coding rules like that when it doesn't appear we have any
> > > experience to indicate we need the extra functionality looks
> > > premature.
> > 
> > Ok, in this case actually I suspect you're right and we can just ditch
> > the exception.  But in general the security discussion is one we should
> > still have.
> 
> People like security.
> 
> Where do we now stand with this patch, and with "[PATCH 4/8] user ns: hook permission"?

Later today I can send a patch against this set which removes the
the init_task exceptions (out of patch 3 and patch 7), but I'd prefer
to leave the MS_SHARED_NS option (patch 6) in.

thanks,
-serge
