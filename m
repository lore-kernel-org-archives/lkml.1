Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZH0N0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZH0N0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZH0N0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:26:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:5448 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZH0N0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OOC39ucA6AHqVlJrlKk/Z8DbA66WUOkrA+88Sl2ry9Ki8YH/nRZXuA/aeOJdAdPs+l
         KLca8Cib1+5O7B64D/EJFP4jztsogMOA53NspuQVVc2dB+lHWBE0muIN8ci2ixS53eiH
         K6Ad7UbTC7BLpv8q/gnkhYKHjK32MfgU7kxLM=
Date: Thu, 27 Aug 2009 15:26:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: remove PERF_SAMPLE_RAW
Message-ID: <20090827132633.GA6058@nowhere>
References: <1251361073.18584.46.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251361073.18584.46.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 10:17:53AM +0200, Peter Zijlstra wrote:
> seems I forgot lkml...
> 
> ---
> Apparently people think trace-events became an ABI the moment perf
> exported them, regardless what the text surrounding PERF_SAMPLE_RAW said
> about the opaqueness of the data provided.


But people think wrong. This is why Steve has written the format files
of trace events, to have a dynamic ABI specification.


> I'm not willing to make anything trace related into an ABI, hence remove
> this.


Geeze!

