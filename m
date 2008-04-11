Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYDKGpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYDKGpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYDKGox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:44:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42545 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbYDKGow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:44:52 -0400
Message-ID: <47FF0881.4010404@cs.helsinki.fi>
Date: Fri, 11 Apr 2008 09:43:13 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.25-rc8-mm2: boot hang after "ACPI: using IOAPIC for interrupt
 routing"
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411062928.GB4748@martell.zuzino.mipt.ru>
In-Reply-To: <20080411062928.GB4748@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Thu, Apr 10, 2008 at 08:33:54PM -0700, Andrew Morton wrote:
>> - git-slub has been temporarily replaced by git-pekka.  Pekka is standing in
>>   while Christoph is away.

Alexey Dobriyan wrote:
> I bisected boot hang after "ACPI: using IOAPIC for interrupt routing"
> down to git-pekka.
> 
> normal dmesg from 2.6.25-rc8-something and .config snippets for -mm

That's odd. I don't immediately see anything there that can cause a 
this... Can you see the hang with the 'for-mm' branch of my tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git

If so, can you do a git bisect? Does sysrq-t tell us anything?

			Pekka

