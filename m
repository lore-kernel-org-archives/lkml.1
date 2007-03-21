Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbXCUXEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbXCUXEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXCUXEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:04:05 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:22753 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753093AbXCUXED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:04:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=afcIxYvjmBUI2pvanCRYzytNs7YOy1gL5zEtj71+UCwRwVtrqWAOJFXktPMybHywceGcdW3tqX+rNjac3vmeCtV+ntWa+cjxq0ZDYVXgcpZ3oRtNPdYSpEqjKUQrPLr8YuEf8O8snX57g7xBx5WS6O2SGIhhVJY3rSw8jTEYTg8=  ;
X-YMail-OSG: cif5W7sVM1nZxqBRgRPRYtNAcwFai5GRYQMz7LEcnpZBciO_sxJIizkJrcGc67twlqSqoimJ5JDPGOa5I1s34lUOCZakpK0LDxiMsDcU16jZ5xLaDdgn5AndC0IgBTJh.MZqpnkl9M262mE-
Message-ID: <4601B9DB.6040104@yahoo.com.au>
Date: Thu, 22 Mar 2007 10:03:55 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Ken Chen <kenchen@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
 helper macros.
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <20070319200513.17168.52238.stgit@localhost.localdomain> <4600B216.3010505@yahoo.com.au> <1174490261.21684.13.camel@localhost.localdomain> <20070321160051.GA5264@infradead.org>
In-Reply-To: <20070321160051.GA5264@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Mar 21, 2007 at 10:17:40AM -0500, Adam Litke wrote:
> 
>>>Also, it is going to be hugepage-only, isn't it? So should the naming be
>>>changed to reflect that? And #ifdef it...
>>
>>They are doing some interesting things on Cell that could take advantage
>>of this.
> 
> 
> That would be new to me.  What we need on Cell is fixing up the
> get_unmapped_area mess which Ben is working on now.
> 
> And let me once again repeat that I don't like this at all.  I'll
> rather have a few ugly ifdefs in strategic places than a big object
> oriented mess like this with just a single user.

I think I agree that we'd need more than one user for this.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
