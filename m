Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbZLSKjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbZLSKjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 05:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZLSKjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 05:39:47 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44637 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZLSKjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 05:39:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=JG92e1aFBFFRLe8J2oOMjVJPt6BENESpV7XODAmIMHgYqsXF5oJZ+EN7nXVNKeHdYR
         9SUP6cNsQ8rNhHkUozpCy0bjrt6KfECzvKgSSdLL9lqfAQtsl7mbRMfOvQ4CG9hn4JpU
         IWqCKC04b4NQY0klvQh83fALN4SW1JEBDqN5A=
Date: Sat, 19 Dec 2009 12:39:36 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] Documentation: update mmiotrace.txt
Message-ID: <20091219123936.1aa3fd1b@daedalus.pq.iki.fi>
In-Reply-To: <4B2C0D68.6080401@oracle.com>
References: <4B2C0D68.6080401@oracle.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 15:16:56 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix typos, spellos, hyphenation, line lengths.
> 
> BTW:  are there some userspace tools?  There is a reference to
> some at the wiki page, but there are no tools listed there.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Pekka Paalanen <pq@iki.fi>
> ---
>  Documentation/trace/mmiotrace.txt |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

Acked-by: Pekka Paalanen <pq@iki.fi>

Yes, there are some shady user space tools. I moved the
references to the mmiotrace developer page:
http://nouveau.freedesktop.org/wiki/MmioTraceDeveloper
People recording traces do not need the tools, so I
removed them from the MmioTrace page to clarify it.

Here "developer" includes people analyzing the traces.
I added a note to the MmioTrace wiki page.

I'm not actively developing nor even maintaining those
tools anymore. I guess hardcore developers do not even need
them, they prefer reading hex. But, the tools should still be
in a working order. The documentation may be a bit scattered.

The tools are in http://cgit.freedesktop.org/~pq/mmio-trace/
and the Rules-ng parts are in
http://nouveau.cvs.sourceforge.net/nouveau/rules-ng/
More information is in the wiki.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
