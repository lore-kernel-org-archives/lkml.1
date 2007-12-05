Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbXLETxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbXLETxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXLETww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:52:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbXLETwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:52:51 -0500
Message-ID: <475702E7.1000607@redhat.com>
Date: Wed, 05 Dec 2007 14:58:31 -0500
From: Dave Anderson <anderson@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030611
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: allow > 2GB executables to run on 64-bit systems
References: <4756C590.9080301@redhat.com> <p73fxyhj5f7.fsf@bingen.suse.de>
In-Reply-To: <p73fxyhj5f7.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Dave Anderson <anderson@redhat.com> writes:
> 
> 
>>When a executable that is greater than 2GB in size is attempted on a 64-bit
>>system on a file system that calls, or uses generic_file_open() as its
>>open handler, it fails with an EOVERFLOW erro.  This patch adds a call
>>to force_o_largefile() call in open_exec(), as done in sys_open() and
>>sys_openat().
> 
> 
> Wouldn't it be better to just always pass O_LARGEFILE unconditionally
> there? e.g. in theory a 2.5GB executable should work on i386 and binfmt_*
> shouldn't have any problems with a large file.
> That would simplify your patch.
> 
> -Andi
> 

I agree in theory.  We've only seen instances on 64-bitters...

Dave

