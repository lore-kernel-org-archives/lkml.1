Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZFXXNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZFXXNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZFXXNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:13:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbZFXXNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:13:31 -0400
Date: Wed, 24 Jun 2009 16:12:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090624161240.3efdbbfa.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906241546380.30928@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
	<20090623131239.711d9f83.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231355130.17001@makko.or.mcafeemobile.com>
	<20090623142511.c9068655.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231423490.17001@makko.or.mcafeemobile.com>
	<20090623144416.04c34268.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906231538280.17001@makko.or.mcafeemobile.com>
	<20090623161852.660cab78.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0906241546380.30928@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 15:47:47 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Tue, 23 Jun 2009, Andrew Morton wrote:
> 
> > Maybe there is such a reason, and it hasn't yet been beaten into my
> > skull.  But I still think it should be done in a separate patch.  One
> > which comes with a full description of the reasons for the change, btw.
> 
> Since your skull seems pretty hard to beat, would you like me to split it 
> for ya? :)

Split what?  My skull?

umm, yes please, I believe the patches should be split.  And I'm still
not seeing the justification for forcing CONFIG_EVENTFD onto all
CONFIG_AIO users!

