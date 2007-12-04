Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXLDGk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXLDGk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 01:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXLDGkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 01:40:16 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35609 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbXLDGkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 01:40:14 -0500
Date: Tue, 4 Dec 2007 01:40:13 -0500
From: Amos Waterland <apw@us.ibm.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Updates to nfsroot documentation
Message-ID: <20071204064012.GA31154@us.ibm.com>
References: <20071204034345.GA30364@us.ibm.com> <20071204042438.GA11229@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204042438.GA11229@verge.net.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 01:24:40PM +0900, Simon Horman wrote:
> On Mon, Dec 03, 2007 at 10:43:45PM -0500, Amos Waterland wrote:
> > The difference between ip=off and ip=::::::off has been a cause of much
> > confusion.  Document how each behaves, and do not contradict ourselves
> > by saying that "off" is the default when in fact "any" is the default
> > and is descibed as being so lower in the file.
> 
> Is that really how it works? If so it sounds a bit silly to me.
> Surely it would be desirable for ip=off and ip=::::::off to
> do the same thing. Or am I missing the point?

Yes, that is how it works.  Pretty confusing, so I figured I'd better
send in a patch to document it.

In the ip=::::::off case, the code in ip_auto_config() sees that
ic_enable is asserted but that ic_myaddr is NONE and proceeds to do
autoconfiguration.

I'd welcome comments from people on whether we should change how it
works instead of just document it.

