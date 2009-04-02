Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbZDBDch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbZDBDch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762184AbZDBDc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:32:27 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:65262 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZDBDcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:32:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0904012207110.32656@qirst.com>
References: <49D0DBA2.20101@vflare.org>
	 <20090401155743.685e2c1e.akpm@linux-foundation.org>
	 <49D400A5.20901@vflare.org>
	 <alpine.DEB.1.10.0904012207110.32656@qirst.com>
Date: Thu, 2 Apr 2009 09:02:22 +0530
Message-ID: <d760cf2d0904012032v4b49ccb3gec64c32d4ba4f13f@mail.gmail.com>
Subject: Re: [PATCH 0/3] compressed in-memory swapping take5
From: Nitin Gupta <ngupta@vflare.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       edt@aei.ca, linux-mm-cc@laptop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 7:39 AM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 2 Apr 2009, Nitin Gupta wrote:
>
>> Justification for this custom allocator is present in xvmalloc changelog
>> itself. It gives reason for not using SLUB and SLOB. During review
>> cycle, I never got any arguments against that justification.
>
> The use of highmem is pretty unique. But that restrict the usefulness to
> 32 bit processors with too much RAM.
>
>

I would again like to mention that apart from highmem, xvmalloc is O(1)
and is very memory efficient too. Sometime in future I hope to present
it as replacement for funny SLOB allocator. For this I will require lot of
data which is another major work....

For now, I will rename xvmalloc to rzmalloc and move it to
drivers/block/ramzswap. As for data to justify ramzswap inclusion
-- its going to be hard. It just 'feels' lot more responsive with compression
but not sure how to quantify this. Maybe I will get some data
by next release.

Thanks to you all for your reviews and suggestions.

Nitin
