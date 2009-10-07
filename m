Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZJGUqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZJGUqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZJGUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:46:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32989
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827AbZJGUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:46:32 -0400
Date: Wed, 07 Oct 2009 13:46:26 -0700 (PDT)
Message-Id: <20091007.134626.238756485.davem@davemloft.net>
To: eranian@gmail.com, eranian@googlemail.com
Cc: paulus@samba.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
 Intel processors
From: David Miller <davem@davemloft.net>
In-Reply-To: <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
References: <1254911461.26976.239.camel@twins>
	<19148.30773.350036.411105@cargo.ozlabs.ibm.com>
	<7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: stephane eranian <eranian@googlemail.com>
Date: Wed, 7 Oct 2009 14:31:58 +0200

> What PPC does is probably the only way to do this given the interface between
> generic and machine-specific code. The one advantage I see is that it works
> inside an event group but also across event groups because that code does not
> look at group boundary, it only looks at the events and the number of available
> registers. The downside is that you duplicate state.
> 
> Did I get this right, Paul?

That's basically how his code works, yes.  I intend on duplicating
it to some extent on sparc64 since I'm operating in a similar
problem space.

So if at least some of this engine went to a generic place, there'd
be at least a 3rd user :-)
