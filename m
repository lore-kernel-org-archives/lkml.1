Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbXFKSFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbXFKSFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXFKSFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:05:11 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:40024 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbXFKSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:05:10 -0400
Message-ID: <466D8E02.3070403@gmail.com>
Date: Mon, 11 Jun 2007 20:01:38 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com> <466D8B0F.3080608@gmail.com> <466D8D4B.8050100@zytor.com>
In-Reply-To: <466D8D4B.8050100@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2007 07:58 PM, H. Peter Anvin wrote:

> Rene Herman wrote:
>> Aligning the kernel image on 4M could gain an additional TLB entry if
>> the kernel image would fit in one (4M aligned) hugepage, but not in the
>> 3M that's left after loading the kernel at 1M physical. And that stuff
>> about the MTRRs...
>>
> 
> Yup.  Most CPUs won't actually use a largepage for the kernel if it's
> below 4 MB (2 MB with PAE, so that's what x86-64 uses.)

Oh, thanks, that's interesting. Had no idea. In those cases it would seem to 
at least potentially be a serious performance issue.

Rene.

