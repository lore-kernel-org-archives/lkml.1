Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYHKRi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYHKRi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYHKRiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:38:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYHKRiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:38:20 -0400
Date: Mon, 11 Aug 2008 13:36:16 -0400
From: Jason Baron <jbaron@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080811173616.GC6103@redhat.com>
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com> <20080808193851.24210bc4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808193851.24210bc4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 07:38:51PM -0700, Randy Dunlap wrote:
> On Fri, 8 Aug 2008 17:51:53 -0400 Jason Baron wrote:
> 
> > Few notes...there is still one control file: <debugfs>/dynamic_printk/modules
> > We can split this up now or later, but I kind of like being able to see all
> > the controls in one file. Also, i've used a djb2 hash function in the code,
> > which i'm not sure is under the correct license/copyright, so i just wanted
> > to point that out as well. see: scripts/basic/hash.c. If its an issue, i can
> > find another hash function. 
> 
> What license does it have?  I don't see one.
> 

hmmm...a search for djb2 finds a number of users, for example, i found this one
which is covered by GPL2, http://www.telegraphics.com.au/svn/dpa/trunk/symtab.c
is that sufficient to say its ok?

i'll clean up the additional points that you raised.

thanks,

-Jason
