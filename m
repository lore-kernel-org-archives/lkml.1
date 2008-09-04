Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYIDQP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYIDQP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYIDQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:15:46 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60311 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYIDQPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:15:45 -0400
Subject: Re: [PATCH] forgotten refcount on sysctl root table
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Parisc List <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080904160557.GT28946@ZenIV.linux.org.uk>
References: <1220540651.3276.16.camel@localhost.localdomain>
	 <20080904160557.GT28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 11:15:43 -0500
Message-Id: <1220544943.3276.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 17:05 +0100, Al Viro wrote:
> 	We should've set refcount on the root sysctl table; otherwise we'll
> blow up the first time we get down to zero dynamically registered sysctl
> tables.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

That fixes the problem,

Thanks,

James


