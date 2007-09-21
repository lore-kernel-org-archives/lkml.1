Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbXIUUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbXIUUNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbXIUUNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:13:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59762 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbXIUUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:13:38 -0400
Date: Fri, 21 Sep 2007 22:11:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: question on kernel rwsem behaviour
Message-ID: <20070921221122.7776e0ec@lappy>
In-Reply-To: <46F3E584.4020301@nortel.com>
References: <46F3E584.4020301@nortel.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 09:38:44 -0600 "Chris Friesen"
<cfriesen@nortel.com> wrote:

> 
> Hi all,
> 
> I just had a quick question on read-write semaphore semantics.  Suppose 
> someone holds a sema for reading, then someone else tries to aquire it 
> for writing, and blocks.  Finally, a third code path tries to aquire it 
> for reading.
> 
> Does this third code path get the sema, or does it wait for the writer?
> 
> Based on looking at the implementation it seems like it waits, but I'd 
> like to confirm that.

Yes, its fair in that sense.
