Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYLEOqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYLEOqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYLEOp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:45:56 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33937 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYLEOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:45:11 -0500
Date: Fri, 5 Dec 2008 08:44:58 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] user namespaces: let user_ns be cloned with
	fairsched
Message-ID: <20081205144458.GB10037@us.ibm.com>
References: <20081203191706.GA16433@us.ibm.com> <alpine.LRH.1.10.0812052106490.14142@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0812052106490.14142@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Wed, 3 Dec 2008, Serge E. Hallyn wrote:
> 
> > (These two patches are in the next-unacked branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/userns-2.6.
> > If they get some ACKs, then I hope to feed this into security-next.
> > After these two, I think we're ready to tackle userns+capabilities)
> 
> These look ok to me, but no acks so far.  Any reason not to apply them?

Thanks for taking a look, James.  Yes, there were specific acks I
was looking for.

Dhaval, could you take a look at the first one and tell me if it
is a problem for fairsched?

Eric, could you take a look at the second one?  Actually, Daniel,
you've played with file capabilities for liblxc - would
http://lkml.org/lkml/2008/12/3/277 be a problem for you?

thanks,
-serge
