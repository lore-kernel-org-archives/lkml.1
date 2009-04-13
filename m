Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZDMVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZDMVrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZDMVrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:47:03 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43624 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZDMVrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:47:01 -0400
Date: Mon, 13 Apr 2009 16:47:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090413214701.GA24509@us.ibm.com>
References: <20090410023539.GK27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023539.GK27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):

Hi Alexey,

as far as I can see, the main differences between this patch and the
equivalent in Oren's tree are:

1. kernel auto-selects container init to freeze
2. kernel freezes tasks
3. no objhash taking references
4. no hbuf
5. always require CAP_SYS_ADMIN

Are there other differences which you would consider meaningful?  Which
do you consider the most important?

Also, since Dave introduced the fops->checkpoint(), we (or at least I)
have been struck by the ugly assymetry with checkpoint() being in fops,
and restart() not.  Do you have an idea for fixing that?

thanks,
-serge
