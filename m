Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZIYUw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZIYUw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZIYUw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:52:26 -0400
Received: from [195.41.46.236] ([195.41.46.236]:58878 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZIYUw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:52:26 -0400
Date: Fri, 25 Sep 2009 22:52:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC Patch] kbuild: remove -Wdeclaration-after-statement
Message-ID: <20090925205219.GA3481@merkur.ravnborg.org>
References: <20090923094034.23512.90809.sendpatchset@localhost.localdomain> <20090923105157.GA31281@merkur.ravnborg.org> <4ABD25AC.30705@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABD25AC.30705@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 01:18:52PM -0700, Randy Dunlap wrote:
> Sam Ravnborg wrote:
> > On Wed, Sep 23, 2009 at 05:38:01AM -0400, Amerigo Wang wrote:
> >> I got lots of "ISO C90 forbids mixed declarations and code" warnings
> >> during compile today's kernel.
> >>
> >> I think we can remove the gcc option '-Wdeclaration-after-statement'
> >> now, since we already have C99 for 10 years. :)
> > 
> > This is a matter of style more than what C99 allows.
> > Kernel style is to fobid this(*) so we keep the warning.
> 
> Agreed.
> 
> > (*) Based on reading several threads where this has
> > been mentioned - I have no specific references to CodingStyle.
> 
> I've avoided making updates to CodingStyle lately.
> Is this one needed?
No - CodingStyle should be general stuff.

	Sam
