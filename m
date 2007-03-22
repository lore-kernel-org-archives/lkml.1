Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXCVPIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXCVPIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXCVPIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:08:46 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50037 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933106AbXCVPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:08:30 -0400
X-Sasl-enc: rw6Vo+mjPZ52kJVkWpXHnCO7szdke3egsvcnyaneneuP 1174576109
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
From: Ian Kent <raven@themaw.net>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070322133153.GB22933@sergelap.austin.ibm.com>
References: <m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	 <20070319200839.GB19449@sergelap.austin.ibm.com>
	 <m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	 <20070320201548.GA21312@sergelap.austin.ibm.com>
	 <m17itbmypc.fsf@ebiederm.dsl.xmission.com>
	 <20070320214125.GA5585@sergelap.austin.ibm.com>
	 <m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com>
	 <1174528851.4635.6.camel@raven.themaw.net>
	 <20070322021931.GA11485@sergelap.austin.ibm.com>
	 <1174533494.4635.37.camel@raven.themaw.net>
	 <20070322133153.GB22933@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 00:06:20 +0900
Message-Id: <1174575980.4635.72.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 08:31 -0500, Serge E. Hallyn wrote:
> > > 
> > > From: "Serge E. Hallyn" <serue@us.ibm.com>
> > > Subject: [PATCH] autofs: prevent pid wraparound in waitqs
> > > 
> > > Instead of storing pid numbers for waitqs, store references
> > > to struct pids.  Also store a reference to the mounter's pid
> > > namespace in the autofs4 sb info so that pid numbers for
> > > mount miss and expiry msgs can send the pid# in the mounter's
> > > pidns.
> > 
> > I think this amounts to what I suggested in my previous replies.
> > Hopefully my comments are enough to clear up any questions on
> > correctness of this approach.
> > 
> > Sorry to be a pain but I'm having a little trouble reviewing the patch
> > because I'm not clear on where the code to handle the automount process
> > group (so called oz_pgrp), from the first patch, fits in with this.
> 
> It also has pidspace infrastructure code in it, so I think we will just
> hold off on this until we have that infrastructure merged into the
> pidspace code and into -mm.  Then we can send you a single, more concise
> patch.

OK great.

I'll have a close look through the code and it's related calls when I
get hold of a complete patch. That will be much easier and mistakes will
be less likely.

Ian


