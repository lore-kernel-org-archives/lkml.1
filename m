Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZFVObl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZFVObl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZFVObd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:31:33 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:45559 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFVObd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:31:33 -0400
Message-ID: <4A3F95A6.5040503@nortel.com>
Date: Mon, 22 Jun 2009 08:31:02 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: Re: [RFC] transcendent memory for Linux
References: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
In-Reply-To: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 14:31:08.0394 (UTC) FILETIME=[15183CA0:01C9F346]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:

> What if there was a class of memory that is of unknown
> and dynamically variable size, is addressable only indirectly
> by the kernel, can be configured either as persistent or
> as "ephemeral" (meaning it will be around for awhile, but
> might disappear without warning), and is still fast enough
> to be synchronously accessible?
> 
> We call this latter class "transcendent memory"

While true that this memory is "exceeding usual limits", the more
important criteria is that it may disappear.

It might be clearer to just call it "ephemeral memory".

There is going to be some overhead due to the extra copying, and at
times there could be two copies of data in memory.  It seems possible
that certain apps right a the borderline could end up running slower
because they can't fit in the regular+ephemeral memory due to the
duplication, while the same amount of memory used normally could have
been sufficient.

I suspect trying to optimize management of this could be difficult.

Chris
