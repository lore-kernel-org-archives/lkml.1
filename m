Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZCBRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZCBRGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZCBRGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:06:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42415 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbZCBRGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:06:03 -0500
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090228205329.GB4254@infradead.org>
References: <20090227203425.F3B51176@kernel>
	 <20090227203431.D1E697CB@kernel>  <20090228205329.GB4254@infradead.org>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 09:05:56 -0800
Message-Id: <1236013556.26788.466.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 15:53 -0500, Christoph Hellwig wrote:
> Also the double-use of the op seem not very nice to me.  Is there any
> real life use case were you would have the operation on a file but
> sometimes not allow checkpoiting?

I'm still reaching here...

I was thinking of /proc.  Opening your own /proc/$$/* would certainly be
considered OK.  But, doing it for some other process not in your pid
namespace would not be OK and would not be checkpointable.

I know we're not quite in real-life territory here, yet, but I'm still
thinking.

-- Dave

