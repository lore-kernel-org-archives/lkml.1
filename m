Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXFYGl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXFYGl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXFYGlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:41:19 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:31674 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753644AbXFYGlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:41:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JF1YikzHXDEdf3J+IlWxJFSUEEgy8brIwzu5RSqqhPGblN+LlInTEV12mCcmM6w128B0RzilAn33hoNsuWjQbNvSPCSFhMYda282ausiTeoAXyJqvS14LmLhiT+Q758DAhMVmK6wztN6XlbCtxL7K9HXSAjtv2IOcxuOzwKkKQQ=  ;
X-YMail-OSG: FZ19sR0VM1kiYAnEF0mJtm0vy2qpVLjUAPWJdbyx_m7R_ROli3lVnV1rmYofcZyLNv0rbGFrrg--
Message-ID: <467F6388.7080101@yahoo.com.au>
Date: Mon, 25 Jun 2007 16:41:12 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
Subject: Re: [patch 10/26] SLUB: Faster more efficient slab determination
 for __kmalloc.
References: <20070618095838.238615343@sgi.com>	<20070618095915.826976488@sgi.com>	<20070619130858.693ae66e.akpm@linux-foundation.org>	<Pine.LNX.4.64.0706191522230.7633@schroedinger.engr.sgi.com>	<20070619152957.a03fbb2c.akpm@linux-foundation.org>	<Pine.LNX.4.64.0706191533580.7633@schroedinger.engr.sgi.com> <20070619154654.218f902c.akpm@linux-foundation.org>
In-Reply-To: <20070619154654.218f902c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 19 Jun 2007 15:38:01 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> 
>>Ok and BUILD_BUG_ON really works? Had some bad experiences with it.
> 
> 
> hm, I don't recall any problems, apart from its very obscure error
> reporting.
> 
> But if it breaks, we get an opportunity to fix it ;)

It doesn't work outside function scope, which can be annoying. The
workaround is to just create a dummy function and put the BUILD_BUG_ON
inside that.

-- 
SUSE Labs, Novell Inc.
