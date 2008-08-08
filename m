Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbYHHTRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbYHHTRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYHHTRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:17:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:58518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbYHHTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:17:38 -0400
Date: Fri, 8 Aug 2008 12:15:19 -0700
From: Greg KH <greg@kroah.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 2/4] integrity: special fs magic
Message-ID: <20080808191519.GA3704@kroah.com>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221742.4444.12.camel@localhost.localdomain> <20080808190448.GA3356@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808190448.GA3356@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:04:48PM -0700, Greg KH wrote:
> On Fri, Aug 08, 2008 at 02:55:42PM -0400, Mimi Zohar wrote:
> >     - Move special fs magic number definitions to magic.h
> >     - Add magic.h include
> >     
> >     Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Why?  What is this patch for?  Are you going to do something with these
> magic values later?

Ok, I now see the follow-up patch that does something with them.

You should say so in this patch.

And is it really ok to be doing things from userspace based on a
filesystem "magic" key?  Those are numbers we have never exported to
userspace before, what happens if they are changed?

thanks,

greg k-h
