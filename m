Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbXFYGSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbXFYGSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXFYGSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:18:09 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:22433 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752152AbXFYGSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:18:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ECJjn0gWuAM4dqwynEJbS8ctJiCpGcX3Kt6B0be7UAv8WNvGLgLc4pWaW6CSrX60444zuS5hv0IT2+mvx9StQPaSuv3o8tZdV1wf9Q5CHtRcbjRt0tP4qWIB5scuZ0LVsSu3k4Nu+Q+ugWHXzQjhQK8j3k3HOv0VDUN6RcaXTMc=  ;
X-YMail-OSG: H6w7BkUVM1mEzE1keSTQb2QkqjybzVOZWzyL7s.ZtrVb_K8I38fE5U0E.Zoh3hbaKvBGlggK8Q--
Message-ID: <467F5E14.5030401@yahoo.com.au>
Date: Mon, 25 Jun 2007 16:17:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: poor man's NUMA support.
References: <20070619090616.GA23697@linux-sh.org>
In-Reply-To: <20070619090616.GA23697@linux-sh.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> This adds preliminary NUMA support to SLOB, primarily aimed at systems
> with small nodes (tested all the way down to a 128kB SRAM block), whether
> asymmetric or otherwise.

Fine by me as well, FWIW. My points about per-cpu/node queues were not
to say that I'm really opposed to getting this in first. In a way, you
sell yourself short with the patch name: the implementation may be just
a basic one, but simplicity is a key point of SLOB... Adding numa
awareness to the slob APIs is obviously a key step and makes it much
easier to experiment with enhancements to the implementation.

Unless it has been picked up already, I'd call it "initial NUMA support"
;) Thanks! Would be great to hear about your experiences using SLOB as
well -- how much memory you're saving, how it performs, etc.

-- 
SUSE Labs, Novell Inc.
