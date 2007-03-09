Return-Path: <linux-kernel-owner+w=401wt.eu-S1767349AbXCIQQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767349AbXCIQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767358AbXCIQQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:16:26 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50846 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767349AbXCIQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:16:24 -0500
Date: Fri, 9 Mar 2007 10:16:18 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, menage@google.com,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, serue@us.ibm.com, containers@lists.osdl.org,
       winget@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 1/2] rcfs core patch
Message-ID: <20070309161618.GD5948@sergelap.austin.ibm.com>
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com> <m1slcg8m4f.fsf@ebiederm.dsl.xmission.com> <20070308101347.GA29051@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308101347.GA29051@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Wed, Mar 07, 2007 at 08:12:00PM -0700, Eric W. Biederman wrote:
> > I have a question?  What does rcfs look like if we start with
> > the code that is in the kernel?  That is start with namespaces
> > and nsproxy and just build a filesystem to display/manipulate them?
> > With the code built so it will support adding resource controllers
> > when they are ready?
> 
> If I am not mistaken, Serge did attempt something in that direction,
> only that it was based on Paul's container patches. rcfs can no doubt
> support the same feature.

My first nsproxy control fs was not based on Paul's set, but was very
nsproxy-specific.  After that I based it on Paul's set.  The nsproxy
subsystem is in Paul's latest patchset.

On top of that set I've posted a set to implement namespace entering,
but that is on hold (or dropped) because the only people so far
interested in namespace entering don't like an fs interface.

If you wanted to take my original non-container fs nsproxy interface and
try to rebuild resource containers on top of them I don't think you'll
get anything better than containers, but then maybe you would...

-serge
