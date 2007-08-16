Return-Path: <linux-kernel-owner+w=401wt.eu-S937697AbXHPBVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937697AbXHPBVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbXHPBVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:21:06 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:40843 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758441AbXHPBVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:21:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=L5CrhetbDRBs1wq6FCTLPz9hLFIDupP15Stk0afimJEl0mHePlbcoyutbZ8sm71xSby2Ek7AEKcZD3QqkT+P5aK5oDhUqOYypKd6VUUM2odJD8EMSjeifbSDqDQULXwTxt95rSr/E5N2aXMbn1r0F5N5pOJxMvFOIYUE4Cdqb9c=  ;
X-YMail-OSG: wAYfujkVM1lUVkvZEunvK_WLE9nPdVRg47k4ylORgt_oz2OtYFWjo8qGQYv.MZYYmghjWbrLVA--
Message-ID: <46C3A675.7050108@yahoo.com.au>
Date: Thu, 16 Aug 2007 11:20:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: paulmck@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, rpjday@mindspring.com, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-arch@vger.kernel.org,
       jesper.juhl@gmail.com, zlynx@acm.org, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, davem@davemloft.net,
       wensong@linux-vs.org, wjiang@resilience.com,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
References: <20070809134150.GA14890@shell.boston.redhat.com> <2708.1186737826@redhat.com> <7680.1186822071@redhat.com> <46BFFDBD.6080804@redhat.com> <46C140DD.3060509@yahoo.com.au> <2cbda24e96a49c3ab7cf7039c515f9fc@kernel.crashing.org> <20070815191829.GJ9645@linux.vnet.ibm.com> <369924c4b3132a4b06258b7ac81b1006@kernel.crashing.org> <20070815195915.GL9645@linux.vnet.ibm.com> <d2cd1065faf8a13040e8a2405c363aa1@kernel.crashing.org> <20070815203836.GO9645@linux.vnet.ibm.com> <7131d547746a998fcec74d1c091f9f6a@kernel.crashing.org>
In-Reply-To: <7131d547746a998fcec74d1c091f9f6a@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> Please check the definition of "cache coherence".
> 
> 
> Which of the twelve thousand such definitions?  :-)

Every definition I have seen says that writes to a single memory
location have a serial order as seen by all CPUs, and that a read
will return the most recent write in the sequence (with a bit of
extra mumbo jumbo to cover store queues and store forwarding).

Within such a definition, I don't see how would be allowed for a
single CPU to execute reads out of order and have the second read
return an earlier write than the first read.

-- 
SUSE Labs, Novell Inc.
