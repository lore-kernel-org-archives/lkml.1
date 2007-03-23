Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbXCWLja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbXCWLja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932960AbXCWLja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:39:30 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:20168 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933204AbXCWLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:39:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gGXSNWZaor/9iBKJAyrq04Yj8iFC+I5BBSm+nR/HljpANlS8GQfrloSfKh9fyRpbg4qLMIppT4zPYA7u4XLFDNXXbNI4ModedfCW/Ote438dUZzBGvcErpqKHS4VdP56aCwv6o3S1hAI8YvWP/968C7r/QMO7hQ1iQDAzR5RoJs=  ;
X-YMail-OSG: 2tP98JkVM1mlHQF0Gx1SuDmwhfD_4m52NRlX0aRCd26gL326jyC.wl5DfurDihvatkMdGREAYGbeozc9RM0V7G9i1dzPNIIVr39qF1HkYVX2PCcqoP.ryNVtHZ8SdCiwm9vl._aUHqyoDA--
Message-ID: <4603BC6C.4010902@yahoo.com.au>
Date: Fri, 23 Mar 2007 22:39:24 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>	<20070322223927.bb4caf43.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com> <20070322234848.100abb3d.akpm@linux-foundation.org>
In-Reply-To: <20070322234848.100abb3d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> but it crashes early in the page allocator (i386) and I don't see why.  It
> makes me wonder if we have a use-after-free which is hidden by the presence
> of the quicklist buffering or something.

Does CONFIG_DEBUG_PAGEALLOC catch it?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
